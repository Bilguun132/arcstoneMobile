//
//  AdminPageViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 22/1/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class AdminPageViewController: UIViewController {
    
    
    @IBOutlet weak var active_batch_number: UILabel!
    @IBOutlet weak var delayed_batch_number: UILabel!
    @IBOutlet weak var on_time_batch: UILabel!
    
    
    var batch_run_list:JSON = ""
    var personnel_list:JSON = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        self.navigationItem.title = "Arcstone"
        show_numbers()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func show_numbers() {
        active_batch_number.text = String(batch_run_list["ActiveBatchRunList"].count)
        delayed_batch_number.text = String(batch_run_list["DelayedBatchRunList"].count)
        on_time_batch.text = String(batch_run_list["ActiveBatchRunList"].count - batch_run_list["DelayedBatchRunList"].count)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_batch_runs" {
            let display_controller = segue.destination as! AdminBatchRunViewController
            display_controller.batch_run_list = self.batch_run_list
        }
        if segue.identifier == "show_personnel_segue" {
            let display_controller = segue.destination as! PersonnelViewController
            display_controller.personnelList = self.personnel_list["PersonnelHeaderList"]
        }
    }
    
    
    // MARK: - Buttons
    
    @IBAction func batch_jobs_button(_ sender: Any) {
        SVProgressHUD.show()
        self.performSegue(withIdentifier: "show_batch_runs", sender: self)
    }
    
    @IBAction func personnel_button(_ sender: Any) {
        SVProgressHUD.show()
        DataController.getData(api_string: "api/Personnel/PersonnelList") {response in
            self.personnel_list = response
            self.performSegue(withIdentifier: "show_personnel_segue", sender: self)
            return
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
}
