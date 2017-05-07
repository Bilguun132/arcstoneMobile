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
import SideMenu

class AdminPageViewController: UIViewController {
    
    //MARK: - Variables
    
    
    @IBOutlet weak var active_batch_number: UILabel!
    @IBOutlet weak var delayed_batch_number: UILabel!
    @IBOutlet weak var paused_batch_number: UILabel!
    @IBOutlet weak var cancelled_batch_number: UILabel!
    @IBOutlet weak var queued_batch_number: UILabel!
    @IBOutlet weak var done_batch_number: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var personnel_onduty: UILabel!
    @IBOutlet weak var personnel_idle: UILabel!
    @IBOutlet weak var machineInUse: UILabel!
    @IBOutlet weak var machineIdle: UILabel!
    
    
    var batch_run_list:JSON = ""
    var personnel_list:JSON = ""
    var machine_list:JSON = ""
    var runningBatchRun: [BatchRun] = []
    var delayedBatchRun: [BatchRun] = []
    var queuedBatchRun: [BatchRun] = []
    var cancelledBatchRun: [BatchRun] = []
    var pausedBatchRun: [BatchRun] = []
    var doneBatchRun: [BatchRun] = []
    var personnelList: [Personnel] = []
    var facilityAssetList: [FacilityAsset] = []
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Arcstone"
        show_numbers()
        setupBorders()
        setupSideMenu()
        SVProgressHUD.dismiss()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: (247/255), green: (247/255), blue: (247/255), alpha: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - User Functions
    
    //populates the different batch run views
    func show_numbers() {
        runningBatchRun = BatchRunMap.mapBatchRuns(batchRunListJson: batch_run_list["runningBatchRunList"])
        delayedBatchRun = BatchRunMap.mapBatchRuns(batchRunListJson: batch_run_list["delayedBatchRunList"])
        queuedBatchRun = BatchRunMap.mapBatchRuns(batchRunListJson: batch_run_list["queuedBatchRunList"])
        cancelledBatchRun = BatchRunMap.mapBatchRuns(batchRunListJson: batch_run_list["cancelledBatchRunList"])
        pausedBatchRun = BatchRunMap.mapBatchRuns(batchRunListJson: batch_run_list["pausedBatchRunList"])
        doneBatchRun = BatchRunMap.mapBatchRuns(batchRunListJson: batch_run_list["doneBatchRunList"])
        
        
        active_batch_number.text = String(runningBatchRun.count)
        delayed_batch_number.text = String(delayedBatchRun.count)
        queued_batch_number.text = String(queuedBatchRun.count)
        paused_batch_number.text = String(pausedBatchRun.count)
        cancelled_batch_number.text = String(cancelledBatchRun.count)
        done_batch_number.text = String(doneBatchRun.count)
        DataController.getData(api_string: DataController.Routes.getAllFacilityAsset) {response in
            var idle = 0
            var busy = 0
            self.facilityAssetList = FacilityAssetMap.mapFacilityAssetList(facilityAssetList: response["facilityAssetList"])
            for int in 0...self.facilityAssetList.count-1 {
                if self.facilityAssetList[int].isAvailable == true {
                    idle += 1
                }
                else {
                    busy += 1
                }
            }
            self.machineIdle.text?.append(String(idle))
            self.machineInUse.text?.append(String(busy))
        }
        DataController.getData(api_string: DataController.Routes.getAllPersonnel) {response in
            var idle = 0
            var busy = 0
            self.personnelList = PersonnelMap.mapUserList(personnelJsonList: response["personnelList"])
            print(self.personnelList.count)
            for int in 0...self.personnelList.count-1 {
                if self.personnelList[int].isAvailable! == true {
                    idle += 1
                }
                else {
                    busy += 1
                }
            }
            self.personnel_idle.text?.append(String(idle))
            self.personnel_onduty.text?.append(String(busy))
        }
    }
    
    
    
    
    func setupBorders() {
        view1.layer.borderWidth = 1
        view1.layer.borderColor = UIColor.darkGray.cgColor
        view1.layer.cornerRadius = 10
        view2.layer.borderWidth = 1
        view2.layer.borderColor = UIColor.darkGray.cgColor
        view2.layer.cornerRadius = 10
        //        view3.roundCorners(corners: .bottomLeft, radius: 10)
        //        view4.roundCorners(corners: .bottomRight, radius: 10)
    }
    
    func setupSideMenu() {
        // Define the menus
        SideMenuManager.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "rightMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuAnimationTransformScaleFactor = 1
        SideMenuManager.menuAnimationFadeStrength = 0.77
        SideMenuManager.menuFadeStatusBar = false
    }
    
    //MARK:
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_active_runs" {
            let display_controller = segue.destination as! AdminBatchRunViewController
            display_controller.BatchRunList = self.runningBatchRun
            display_controller.navigationItem.title = "Active"
        }
        if segue.identifier == "show_delayed_runs" {
            let display_controller = segue.destination as! AdminBatchRunViewController
            display_controller.BatchRunList = self.delayedBatchRun
            display_controller.navigationItem.title = "Delayed"
        }
        
        if segue.identifier == "show_cancelled_runs" {
            let display_controller = segue.destination as! AdminBatchRunViewController
            display_controller.BatchRunList = self.cancelledBatchRun
            display_controller.navigationItem.title = "Cancelled"
        }
        
        if segue.identifier == "show_paused_runs" {
            let display_controller = segue.destination as! AdminBatchRunViewController
            display_controller.BatchRunList = self.pausedBatchRun
            display_controller.navigationItem.title = "Paused"
        }
        
        if segue.identifier == "show_queued_runs" {
            let display_controller = segue.destination as! AdminBatchRunViewController
            display_controller.BatchRunList = self.queuedBatchRun
            display_controller.navigationItem.title = "Queued"
        }
        
        if segue.identifier == "show_done_runs" {
            let display_controller = segue.destination as! AdminBatchRunViewController
            display_controller.BatchRunList = self.doneBatchRun
            display_controller.navigationItem.title = "Done"
        }
        
        if segue.identifier == "show_personnel_segue" {
            let display_controller = segue.destination as! PersonnelViewController
            display_controller.personnelList = self.personnelList
            display_controller.navigationItem.title = "Personnel"
        }
        if segue.identifier == "show_machines_segue" {
            let display_controller = segue.destination as! MachinesViewController
            display_controller.facilityList = self.facilityAssetList
            display_controller.navigationItem.title = "Machines"
        }
    }
    
    
    // MARK: - Buttons
    
    @IBAction func get_active_runs_button(_ sender: Any) {
        SVProgressHUD.show()
        self.performSegue(withIdentifier: "show_active_runs", sender: self)
    }
    
    @IBAction func get_delayed_runs_button(_ sender: Any) {
        SVProgressHUD.show()
        self.performSegue(withIdentifier: "show_delayed_runs", sender: self)
    }
    
    @IBAction func get_queued_runs_button(_ sender: Any) {
        SVProgressHUD.show()
        self.performSegue(withIdentifier: "show_queued_runs", sender: self)
    }
    
    @IBAction func get_paused_runs_button(_ sender: Any) {
        SVProgressHUD.show()
        self.performSegue(withIdentifier: "show_paused_runs", sender: self)
    }
    
    @IBAction func get_cancelled_runs_button(_ sender: Any) {
        SVProgressHUD.show()
        self.performSegue(withIdentifier: "show_cancelled_runs", sender: self)
    }
    
    @IBAction func get_done_runs_button(_ sender: Any) {
        SVProgressHUD.show()
        self.performSegue(withIdentifier: "show_done_runs", sender: self)
    }
    
    
    @IBAction func personnel_button(_ sender: Any) {
        SVProgressHUD.show()
        DataController.getData(api_string: DataController.Routes.getAllPersonnel) {response in
            self.personnel_list = response["personnelList"]
            self.performSegue(withIdentifier: "show_personnel_segue", sender: self)
            return
        }
    }
    @IBAction func machines_button(_sender:Any) {
        SVProgressHUD.show()
        DataController.getData(api_string: DataController.Routes.getAllFacilityAsset) {response in
            self.machine_list = response
            self.performSegue(withIdentifier: "show_machines_segue", sender: self)
            return
        }
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
