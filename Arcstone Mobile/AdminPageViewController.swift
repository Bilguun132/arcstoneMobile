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
    @IBOutlet weak var paused_batch_number: UILabel!
    @IBOutlet weak var cancelled_batch_number: UILabel!
    @IBOutlet weak var on_time_batch_number: UILabel!
    @IBOutlet weak var delivered_batch_number: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var personnel_onduty: UILabel!
    @IBOutlet weak var personnel_idle: UILabel!
    
    
    
    
    
    var batch_run_list:JSON = ""
    var personnel_list:JSON = ""
    var machine_list:JSON = ""
    var active_batch_run_list:JSON = ""
    var delayed_batch_run_list:JSON = ""
    var ontTime_batch_run_list:JSON = ""
    var cancelled_batch_run_list:JSON = ""
    var paused_batch_run_list:JSON = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        self.navigationItem.title = "Arcstone"
        show_numbers()
        setupBorders()
        personnel_onduty.text?.append("2")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func show_numbers() {
        active_batch_number.text = String(batch_run_list["ActiveBatchRunList"].count)
        delayed_batch_number.text = String(batch_run_list["DelayedBatchRunList"].count)
        on_time_batch_number.text = String(batch_run_list["OnTimeBatchRunList"].count)
        paused_batch_number.text = String(batch_run_list["PausedBatchRunList"].count)
        cancelled_batch_number.text = String(batch_run_list["CancelledBatchRunList"].count)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_active_runs" {
            let display_controller = segue.destination as! AdminBatchRunViewController
            display_controller.batch_run_list = self.active_batch_run_list
            display_controller.navigationItem.title = "Active"
        }
        if segue.identifier == "show_delayed_runs" {
            let display_controller = segue.destination as! AdminBatchRunViewController
            display_controller.batch_run_list = self.delayed_batch_run_list
             display_controller.navigationItem.title = "Delayed"
        }
        
        if segue.identifier == "show_cancelled_runs" {
            let display_controller = segue.destination as! AdminBatchRunViewController
            display_controller.batch_run_list = self.cancelled_batch_run_list
             display_controller.navigationItem.title = "Cancelled"
        }
        
        if segue.identifier == "show_paused_runs" {
            let display_controller = segue.destination as! AdminBatchRunViewController
            display_controller.batch_run_list = self.paused_batch_run_list
            display_controller.navigationItem.title = "Paused"
        }
        
        if segue.identifier == "show_ontime_runs" {
            let display_controller = segue.destination as! AdminBatchRunViewController
            display_controller.batch_run_list = self.ontTime_batch_run_list
             display_controller.navigationItem.title = "On time"
        }
        
        if segue.identifier == "show_personnel_segue" {
            let display_controller = segue.destination as! PersonnelViewController
            display_controller.personnelList = self.personnel_list["PersonnelHeaderList"]
             display_controller.navigationItem.title = "Personnel"
        }
        if segue.identifier == "show_machines_segue" {
            let display_controller = segue.destination as! MachinesViewController
            display_controller.machine_list = self.machine_list["FacilityHeaderList"]
             display_controller.navigationItem.title = "Machines"
        }
    }
    
    
    // MARK: - Buttons
    
    @IBAction func get_active_runs_button(_ sender: Any) {
        SVProgressHUD.show()
        self.active_batch_run_list = self.batch_run_list["ActiveBatchRunList"]
        self.performSegue(withIdentifier: "show_active_runs", sender: self)
    }
    
    @IBAction func get_delayed_runs_button(_ sender: Any) {
        SVProgressHUD.show()
        self.delayed_batch_run_list = self.batch_run_list["DelayedBatchRunList"]
        self.performSegue(withIdentifier: "show_delayed_runs", sender: self)
    }
    
    @IBAction func get_onTime_runs_button(_ sender: Any) {
        SVProgressHUD.show()
        self.ontTime_batch_run_list = self.batch_run_list["OnTimeBatchRunList"]
        self.performSegue(withIdentifier: "show_ontime_runs", sender: self)
    }
    
    @IBAction func get_paused_runs_button(_ sender: Any) {
        SVProgressHUD.show()
        self.paused_batch_run_list = self.batch_run_list["PausedBatchRunList"]
        self.performSegue(withIdentifier: "show_paused_runs", sender: self)
    }
    
    @IBAction func get_cancelled_runs_button(_ sender: Any) {
        SVProgressHUD.show()
        self.cancelled_batch_run_list = self.batch_run_list["CancelledBatchRunList"]
        self.performSegue(withIdentifier: "show_cancelled_runs", sender: self)
    }
    
    @IBAction func personnel_button(_ sender: Any) {
        SVProgressHUD.show()
        DataController.getData(api_string: "api/Personnel/PersonnelList") {response in
            self.personnel_list = response
            self.performSegue(withIdentifier: "show_personnel_segue", sender: self)
            return
        }
    }
    @IBAction func machines_button(_sender:Any) {
        SVProgressHUD.show()
        DataController.getData(api_string: "api/Facility/FacilityList") {response in
            self.machine_list = response
            self.performSegue(withIdentifier: "show_machines_segue", sender: self)
            return
        }
    }
    
    func setupBorders() {
        view1.layer.borderWidth = 1
        view1.layer.borderColor = UIColor.darkGray.cgColor
        view1.layer.cornerRadius = 10
        view2.layer.borderWidth = 1
        view2.layer.borderColor = UIColor.darkGray.cgColor
        view2.layer.cornerRadius = 10
        view3.roundCorners(corners: .bottomLeft, radius: 10)
        view4.roundCorners(corners: .bottomRight, radius: 10)
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

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
