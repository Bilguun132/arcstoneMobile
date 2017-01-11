//
//  ShowJobViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 20/12/16.
//  Copyright © 2016 Bilguun. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class ShowJobViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populate_view()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Variables
    
    @IBOutlet weak var job_text: UILabel!
    @IBOutlet weak var batch_template_id_text: UITextField!
    @IBOutlet weak var batch_id_text: UITextField!
    @IBOutlet weak var scheduled_date_text: UITextField!
    @IBOutlet weak var completion_date_text: UITextField!
    @IBOutlet weak var image_view: UIImageView!
    
    var index_json_data:JSON = ""
    var batch_template_id = ""
    var batch_run_id = ""
    var batch_template_step_json:JSON = ""
    var batch_run_step_json:JSON = ""
    
    //MARK: - User Functions
    
    func populate_view(){
        job_text.text = index_json_data["Name"].stringValue
        batch_template_id_text.text = index_json_data["Batch_template_id"].stringValue
        batch_id_text.text = index_json_data["Id"].stringValue
        scheduled_date_text.text =  (index_json_data["Scheduled_start_date_time"].stringValue).substring(to: 10)
        completion_date_text.text = index_json_data["Last_update"].stringValue.substring(to: 10)
        batch_template_id = index_json_data["Batch_template_id"].stringValue
        batch_run_id = index_json_data["Id"].stringValue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_steps" {
            let display_controller = segue.destination as! AvailableJobsViewController
            display_controller.batch_template_step_json = self.batch_template_step_json
            display_controller.batch_run_step_json = self.batch_run_step_json
        }
    }
    
    @IBAction func batch_button_pressed(_ sender: Any) {
        SVProgressHUD.show()
        //        DataController.getData(api_string: "api/Batchtemplatestep/BatchTemplateStepListByBatchTemplateID?templateID="+(self.batch_template_id)) {response in
        //            self.batch_template_step_json = response["BatchtemplatestepHeaderList"]
        DataController.getData(api_string: "api/Batchrunstep/BatchrunstepListByBatchRunID?batchrunID="+(self.batch_run_id)) {response in
            self.batch_run_step_json = response["BatchrunstepHeaderList"]
            self.performSegue(withIdentifier: "show_steps", sender: self)
        }
    }
}

//MARK: - String Extensions

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}
