//
//  BatchRunStatusViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 22/12/16.
//  Copyright © 2016 Bilguun. All rights reserved.
//

import UIKit
import SwiftyJSON
import DropDown
import Alamofire
import SVProgressHUD

class BatchRunStatusViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Status"
//        setupDropDowns()
        print(run_step_info)
        batch_run_step_id = run_step_info["Id"].stringValue
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.dismiss(animated: true, completion: nil)
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Variables
    
    var run_step_info:JSON = ""
    var current_status = ""
    var image_string = "No image"
    var run_step_id = ""
    var current_time = ""
    var batch_run_id = ""
    var personnel_id = ""
    var run_step_parameters:JSON = ""
    var batch_run_step_id = ""
    
    
    @IBOutlet weak var confirm_button: UIButton!
    @IBOutlet weak var choose_status_button: UIButton!
    @IBOutlet weak var report_issue_button: UIButton!
    @IBOutlet weak var image_picked: UIImageView!
    
    //MARK: - DropDowns
    
    let chooseStatusDropDown = DropDown()
    
    
    func setupDropDowns() {
        chooseStatusDropDown.anchorView = choose_status_button
        chooseStatusDropDown.bottomOffset = CGPoint(x: 0, y: choose_status_button.bounds.height)
        chooseStatusDropDown.dataSource = DataController.Constants.status_names
        chooseStatusDropDown.selectionAction = { [unowned self] (index, item) in
            self.choose_status_button.setTitle(item, for: .normal)
        }
        chooseStatusDropDown.selectRowAtIndex(3)
    }
    
    
    //MARK: - Buttons
    
    @IBAction func checklist_button_pressed(_ sender: Any) {
        SVProgressHUD.show()
        DataController.getData(api_string: "api/Batchrunstepparameter/BatchrunstepparameterListByBatchRunStepID?param_id="+(self.batch_run_step_id)) {response in
            self.run_step_parameters = response["BatchrunstepparameterHeaderList"]
            self.performSegue(withIdentifier: "show_parameter_segue", sender: self)
        }
    }
    
    
    @IBAction func print_image_string_pressed(_ sender: Any) {
        print(image_string.getBytes)
        let size = image_string.characters.count
        print(size)
    }
    
    @IBAction func stop_button_pressed(_ sender: Any) {
        let message:Parameters = form_message(start: false)
        DataController.postData(api_string: "api/Batchrunstep/StopBatchrunstep", post_message : message) {response in
            if response != "0" {
                print("Stopped")
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func start_button_pressed(_ sender: Any) {
        let message:Parameters = form_message(start: true)
        DataController.postData(api_string: "api/Batchrunstep/StartBatchrunstep", post_message : message) {response in
            if response != "0" {
                print("Started")
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    @IBAction func status_button_pressed(_ sender: AnyObject) {
        _ = chooseStatusDropDown.show()
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
    
    func form_message(start:Bool) -> [String:Any] {
        run_step_id = run_step_info["Id"].stringValue
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let start_date = dateFormatter.string(from: date as Date)
        current_time = start_date
        batch_run_id = run_step_info["Batch_run_id"].stringValue
        personnel_id = UserDefaults.standard.string(forKey: "PersonnelID")!
        if start {
            let message = ["Id" : run_step_id, "Start_date_time" : current_time, "Batch_run_id" : batch_run_id, "Personnel_id" : personnel_id]
            return message
        }
        else {
            let message = ["Id" : run_step_id, "End_date_time" : current_time, "Batch_run_id" : batch_run_id, "Personnel_id" : personnel_id]
            return message
        }
        
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
            display_controller.batch_run_step_parameter = run_step_parameters
        }
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
