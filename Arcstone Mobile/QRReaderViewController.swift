//
//  QRReaderViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 25/2/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD
import SwiftyJSON

class QRReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    //MARK: - Variables
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var batchRunID = ""
    var batchStepID = ""
    var JSONData: JSON = ""
    
    @IBOutlet var messageLabel:UILabel!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Scan"
        setupVideo()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        captureSession?.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - User Functions
    
    func clearView() {
        qrCodeFrameView?.frame = CGRect.zero
        messageLabel.text = "No QR code is detected"
    }
    
    func setupVideo() {
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypePDF417Code]
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Move the message label and top bar to the front
        view.bringSubview(toFront: messageLabel)
        
        // Start video capture.
        captureSession?.startRunning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first! as UITouch
        let screenSize = view.bounds.size
        let focusPoint = CGPoint(x: touchPoint.location(in: view).y / screenSize.height, y: 1.0 - touchPoint.location(in: view).x / screenSize.width)
        
        if let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) {
            do {
                try device.lockForConfiguration()
                if device.isFocusPointOfInterestSupported {
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = AVCaptureFocusMode.autoFocus
                }
                if device.isExposurePointOfInterestSupported {
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureExposureMode.autoExpose
                }
                device.unlockForConfiguration()
                
            } catch {
                // Handle errors here
            }
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        captureSession?.stopRunning()
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            captureSession?.startRunning()
            return
        }
        
        if (UserDefaults.standard.string(forKey: "QRBatchStepCode")) == nil || UserDefaults.standard.string(forKey: "QRBatchRunCode") == nil || UserDefaults.standard.string(forKey: "QRPrefix") == nil {
            EZAlertController.alert("Alert", message: "QR Settings have not been made")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        view.bringSubview(toFront: qrCodeFrameView!)
        let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
        qrCodeFrameView?.frame = barCodeObject!.bounds
        
        if metadataObj.stringValue != nil {
            SVProgressHUD.show()
            messageLabel.text = metadataObj.stringValue
            print(messageLabel.text!)
            let message = metadataObj.stringValue
            if message!.characters.first ==  UserDefaults.standard.string(forKey: "QRPrefix")?.characters.first {
                
                if message!.contains(UserDefaults.standard.string(forKey: "QRBatchRunCode")!) {
                    print(message?.substring(from: 1).substring(to: (UserDefaults.standard.string(forKey: "QRBatchRunCode")?.characters.count)!) as Any)
                    print(UserDefaults.standard.string(forKey: "QRBatchRunCode")!)
                    if message?.substring(from: 1).substring(to: (UserDefaults.standard.string(forKey: "QRBatchRunCode")?.characters.count)!) == UserDefaults.standard.string(forKey: "QRBatchRunCode")! {
                        let index = message?.index((message?.startIndex)!, offsetBy: (UserDefaults.standard.string(forKey: "QRBatchRunCode")?.characters.count)! + 1)
                        self.batchRunID = (message?.substring(from: index!))!
                        print(self.batchRunID)
                        DataController.getData(api_string: "api/Batchrun/BatchrunByID?param_id="+(self.batchRunID)) {response in
                            if response["BatchrunHeaderList"].count == 0 {
                                EZAlertController.alert("Batch Run does not exist")
                                _ = self.navigationController?.popToRootViewController(animated: true)
                            }
                            self.JSONData = response["BatchrunHeaderList"]
                            print(self.JSONData)
                            self.performSegue(withIdentifier: "show_batch_run", sender: self)
                            SVProgressHUD.dismiss()
                        }
                    }
                }
                
                if message!.contains(UserDefaults.standard.string(forKey: "QRBatchStepCode")!) {
                    print(message?.substring(from: 1).substring(to: (UserDefaults.standard.string(forKey: "QRBatchStepCode")?.characters.count)!) as Any)
                    if message?.substring(from: 1).substring(to: (UserDefaults.standard.string(forKey: "QRBatchStepCode")?.characters.count)!) == UserDefaults.standard.string(forKey: "QRBatchStepCode")! {
                        let index = message?.index((message?.startIndex)!, offsetBy: (UserDefaults.standard.string(forKey: "QRBatchStepCode")?.characters.count)! + 1)
                        self.batchStepID = (message?.substring(from: index!))!
                        print(self.batchStepID)
                        DataController.getData(api_string: "api/Batchrunstep/BatchrunstepByID?param_id="+(self.batchStepID)) {response in
                            print(response.count)
                            print(response)
                            print(response["BatchrunstepHeaderList"].count)
                            if response["BatchrunstepHeaderList"].count == 0 {
                                EZAlertController.alert("Batch Step does not exist")
                                _ = self.navigationController?.popToRootViewController(animated: true)
                            }
                            self.JSONData = response["BatchrunstepHeaderList"]
                            print(self.JSONData)
                            self.performSegue(withIdentifier: "show_batch_step", sender: self)
                            SVProgressHUD.dismiss()
                        }
                    }
                }
            }
        }
        SVProgressHUD.dismiss()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_batch_run" {
            let display_controller = segue.destination as! ShowJobViewController
            display_controller.index_json_data = self.JSONData[0]
            //            self.dismiss(animated: false, completion: nil)
        }
        
        if segue.identifier == "show_batch_step" {
            let display_controller = segue.destination as! BatchRunStatusViewController
            display_controller.run_step_info = self.JSONData[0]
            display_controller.current_status = self.JSONData[0]["Status"].stringValue
            display_controller.batch_run_id = self.JSONData[0]["Batch_run_id"].stringValue
            display_controller.batch_step_name = self.JSONData[0]["Name"].stringValue
            display_controller.batch_run_name = self.JSONData[0]["Batch_run_name"].stringValue
        }
    }
}

extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                substring(with: substringFrom..<substringTo)
            }
        }
    }
}
