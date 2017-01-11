//
//  BatchRunStepParameterInfoViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 7/1/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import Alamofire

class BatchRunStepParameterInfoViewController: UIViewController, UITextViewDelegate {
    
    var batch_step_parameter_info:JSON = ""
    var batch_run_para_id = ""
    
    @IBOutlet weak var para_name: UITextField!
    @IBOutlet weak var expected_value: UITextField!
    @IBOutlet weak var actual_value: UITextField!
    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var notes_textview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        self.navigationItem.title = "Parameters"
        populate()
        print(batch_step_parameter_info)
        batch_run_para_id = batch_step_parameter_info["Id"].stringValue
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        notes_textview.sizeToFit()
    }
    
    
    @IBAction func update_para_button_clicked(_ sender: Any) {
        //        if actual_value.text != "" {
        batch_step_parameter_info["Actual_value"].stringValue = actual_value.text!
        //            let message = ["Id" : batch_run_para_id, "Actual_value" : actual_value.text!] as [String : Any]
        let message = batch_step_parameter_info.dictionaryObject
        DataController.postData(api_string: "api/Batchrunstepparameter/UpdateBatchrunstepparameter", post_message : message!) {response in
            if response != "0" {
                print("Updated")
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func populate(){
        para_name.text = batch_step_parameter_info["Name"].stringValue
        expected_value.text = batch_step_parameter_info["Expected_value"].stringValue
        actual_value.text = batch_step_parameter_info["Actual_value"].stringValue
        notes_textview.text = batch_step_parameter_info["Template_notes"].stringValue
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
