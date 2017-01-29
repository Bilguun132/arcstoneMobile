//
//  AdminViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 21/1/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class AdminViewController: UIViewController {
    
    var personnel_info_id = ""
    var batch_run_list_json_by_personnelID:JSON = ""
    var batch_run_list:JSON = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        print(personnel_info_id)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func show_work_button_clicked(_ sender: Any) {
        SVProgressHUD.show()
        DataController.getData(api_string: "api/Batchrun/BatchrunListByPersonnelID?personnelID="+(self.personnel_info_id)) {response in
            self.batch_run_list_json_by_personnelID = response
            self.performSegue(withIdentifier: "view_work_segue", sender: self)
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "view_work_segue" {
            let display_controller = segue.destination as! BatchRunListViewController
            display_controller.batch_run_list_json_by_personnelID = self.batch_run_list_json_by_personnelID
            display_controller.personnel_id = self.personnel_info_id
        }
        if segue.identifier == "admin_page_segue" {
            let display_controller = segue.destination as! AdminPageViewController
            display_controller.batch_run_list = self.batch_run_list
        }
    }
    
    @IBAction func admin_page_button(_ sender: Any) {
        SVProgressHUD.show()
        DataController.getData(api_string: "api/Batchrun/BatchrunList") {response in
            self.batch_run_list = response
            self.performSegue(withIdentifier: "admin_page_segue", sender: self)
            return
        }
    }
}
