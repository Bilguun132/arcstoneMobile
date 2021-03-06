//
//  BatchRunStatusViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 22/12/16.
//  Copyright © 2016 Bilguun. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import SideMenu

class BatchRunStatusViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjust_buttons()
        setup()
        print(batchRunStep!)
        setupSideMenu()
        //        setupDropDowns()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.dismiss(animated: true, completion: nil)
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setColors()
    }
    
    //MARK: - Variables
    
    var batchRunStep: BatchRunStep?
    var current_status = ""
    var image_string = "No image"
    var run_step_id = ""
    var current_time = ""
    var batch_run_id = ""
    var batch_step_name = ""
    var batch_run_name = ""
    var personnel_id = ""
    var batchRunStepParameters: [batchRunStepParameter]?
    var batch_run_step_id = ""
    var secondSince = 0
    var hours = 0
    var minutes = 0
    var second = 0
    var timer = Timer()
    
    @IBOutlet weak var batch_step_text_name: UILabel!
    @IBOutlet weak var batch_run_text_name: UILabel!
    @IBOutlet weak var choose_status_button: UIButton!
    @IBOutlet weak var report_issue_button: UIButton!
    @IBOutlet weak var image_picked: UIImageView!
    @IBOutlet weak var start_button: UIButton!
    @IBOutlet weak var pause_button: UIButton!
    @IBOutlet weak var stop_button: UIButton!
    @IBOutlet weak var checklist_button: UIButton!
    @IBOutlet weak var timer_label:UILabel!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var startDarkView: UIView!
    @IBOutlet weak var pauseDarkView: UIView!
    @IBOutlet weak var stopDarkView: UIView!
    @IBAction func unwindToBatchRunStatusView(segue:UIStoryboardSegue) { }
    
    
    //MARK: - Buttons
    
    @IBAction func checklist_button_pressed(_ sender: Any) {
        SVProgressHUD.show()
        DataController.getData(api_string: DataController.Routes.getAllBatchRunStepParametersByBatchRunStepId + String(describing: (self.batchRunStep!.id))) {response in
            self.batchRunStepParameters = batchRunStepParameterMap.mapBatchRunStepParameterList(batchRunStepParameterListJSON: response["batchRunStepParameterList"])
            self.performSegue(withIdentifier: "show_parameter_segue", sender: self)
        }
    }
    
    @IBAction func pause_button_pressed(_ sender: Any) {
        self.timer.invalidate()
        SVProgressHUD.show()
        let message:Parameters = form_message(start: false)
        DataController.postData(api_string: DataController.Routes.pauseBatchRunStep, post_message : message) {response in
            if response["ResponseCode"] != "0" {
                print("Paused")
                self.current_status = "6"
                self.viewDidAppear(false)
                self.adjust_buttons()
            }
        }
        SVProgressHUD.dismiss()
    }
    
    @IBAction func print_image_string_pressed(_ sender: Any) {
        print(image_string.getBytes)
        let size = image_string.characters.count
        print(size)
    }
    
    @IBAction func stop_button_pressed(_ sender: Any) {
        self.timer.invalidate()
        SVProgressHUD.show()
        let message:Parameters = form_message(start: false)
        DataController.postData(api_string: DataController.Routes.stopBatchRunStep, post_message : message) {response in
            if response["ResponseCode"] != "0" {
                print("Stopped")
                self.current_status = "5"
                self.viewDidAppear(false)
                self.adjust_buttons()
            }
        }
        SVProgressHUD.dismiss()
    }
    
    @IBAction func start_button_pressed(_ sender: Any) {
        self.timer.invalidate()
        SVProgressHUD.show()
        let message:Parameters = form_message(start: true)
        DataController.postData(api_string: DataController.Routes.startBatchRunStep, post_message : message) {response in
            if response["ResponseCode"] != "0" {
                print("Started")
                self.current_status = "3"
                self.viewDidAppear(false)
                self.adjust_buttons()
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countdown), userInfo: nil, repeats: true)
            }
        }
        SVProgressHUD.dismiss()
    }
    
    
    @IBAction func report_issue_button_pressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func open_library_pressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: - Support Functions
    
    func setColors() {
        print(self.current_status)
        let status = DataController.convert_batch_run_step_status(number: self.current_status)
        self.navigationController?.navigationBar.barTintColor = status.1
        self.navigationItem.title = status.0
        self.timerView.backgroundColor = status.1
    }
    
    func setup() {
        let status = DataController.convert_batch_run_step_status(number: self.current_status)
        self.navigationController?.navigationBar.barTintColor = status.1
        self.navigationItem.title = status.0
        batch_step_text_name.text = self.batch_step_name
        batch_run_text_name.text = self.batch_run_name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let start_string = batchRunStep?.startDateTime
        if start_string == "" {
            timer_label.text = "00:00:00"
            return
        }
        else {
            let start_date = dateFormatter.date(from: start_string!.substring(to: 19))
            secondSince = Int(Date.init().timeIntervalSince(start_date!))
            hours = secondSince / 3600
            minutes = ( secondSince % 3600 ) / 60
            second = (secondSince % 3600) % 60
            timer_label.text = String(format: "%02d:%02d:%02d", arguments: [hours, minutes, second])
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        }
    }
    
    func countdown() {
        if current_status == "5" || current_status == "6" {
            return
        }
        secondSince = secondSince + 1
        hours = secondSince / 3600
        minutes = ( secondSince % 3600 ) / 60
        second = (secondSince % 3600) % 60
        timer_label.text = String(format: "%02d:%02d:%02d", arguments: [hours, minutes, second])
        
    }
    
    func form_message(start:Bool) -> [String:Any] {
        let message = ["id" : batchRunStep!.id]
        return message as Any as! [String : Any]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let resized_image = selectedImage.resizeWith(percentage: 0.3)
        //        image_picked.image = resized_image
        //        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        let imageData:NSData = UIImagePNGRepresentation(resized_image!)! as NSData
        image_string = imageData.base64EncodedString(options: .lineLength64Characters)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_parameter_segue" {
            let display_controller = segue.destination as! BatchRunStepParameterTableViewController
            display_controller.batchRunStepParameterList = batchRunStepParameters
        }
    }
    
    func adjust_buttons() {
        if current_status == "3" {
            start_button.isEnabled = false
            pause_button.isEnabled = true
            stop_button.isEnabled = true
            start_button.setTitle("Running", for: .normal)
            pause_button.setTitle("Pause", for: .normal)
            startDarkView.alpha = 1
            pauseDarkView.alpha = 0
        }
        else if current_status == "5" {
            start_button.isEnabled = false
            pause_button.isEnabled = false
            stop_button.isEnabled = false
            start_button.setTitle("Completed", for: .normal)
            pause_button.setTitle("Completed", for: .normal)
            stop_button.setTitle("Completed", for: .normal)
            startDarkView.alpha = 1
            pauseDarkView.alpha = 1
            stopDarkView.alpha = 1
        }
        else if current_status == "6" {
            start_button.isEnabled = true
            pause_button.isEnabled = false
            stop_button.isEnabled = true
            pause_button.setTitle("Paused", for: .normal)
            start_button.setTitle("Start", for: .normal)
            pauseDarkView.alpha = 1
            startDarkView.alpha = 0
        }
    }
    
    func setupSideMenu() {
        // Define the menus
        SideMenuManager.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "rightMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuAnimationTransformScaleFactor = 1
        SideMenuManager.menuAnimationFadeStrength = 0.77
        SideMenuManager.menuFadeStatusBar = false
    }
}

//MARK: - Image Resize Function

extension UIImage {
    func resizeWith(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}


//Encoding
//let userImage:UIImage = UIImage(named: "Your-Image_name")!
//let imageData:NSData = UIImagePNGRepresentation(userImage)! as NSData
//let dataImage = imageData.base64EncodedString(options: .lineLength64Characters)
//Decoding
//let imageData = dataImage
//let dataDecode:NSData = NSData(base64Encoded: imageData!, options:.ignoreUnknownCharacters)!
//let avatarImage:UIImage = UIImage(data: dataDecode as Data)!
//yourImageView.image = avatarImage
