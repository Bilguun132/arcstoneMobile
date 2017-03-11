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
import SideMenu

class AdminViewController: UIViewController {
    
    //MARK: - Variables
    
    var personnel_info_id = ""
    var batch_run_list_json_by_personnelID:JSON = ""
    var batch_run_list:JSON = ""
    
    @IBOutlet weak var realTimeView: UIView!
    @IBOutlet weak var WorkstationView: UIView!
    @IBOutlet weak var dashboardView: UIView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        //        self.navigationItem.backBarButtonItem?.isEnabled = false
        setupSideMenu()
        setupBorders()
        print(batch_run_list)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: (247/255), green: (247/255), blue: (247/255), alpha: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Buttons
    @IBAction func show_work_button_clicked(_ sender: Any) {
        SVProgressHUD.show()
        DataController.getData(api_string: "api/Batchrun/BatchrunList") {response in
            self.batch_run_list_json_by_personnelID = response
            self.performSegue(withIdentifier: "view_work_segue", sender: self)
            return
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.setValue("nil", forKey: "PersonnelID")
        self.performSegue(withIdentifier: "back_to_login", sender: self)
    }
    
    @IBAction func admin_page_button(_ sender: Any) {
        SVProgressHUD.show()
        DataController.getData(api_string: "api/Batchrun/BatchrunList") {response in
            self.batch_run_list = response
            self.performSegue(withIdentifier: "admin_page_segue", sender: self)
            return
        }
    }
    
    
    //MARK:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "view_work_segue" {
            let display_controller = segue.destination as! AdminBatchRunViewController
            display_controller.batch_run_list = self.batch_run_list_json_by_personnelID["RunningBatchRunList"]
        }
        if segue.identifier == "admin_page_segue" {
            let display_controller = segue.destination as! AdminPageViewController
            display_controller.batch_run_list = self.batch_run_list
        }
    }
    @IBAction func unwindToAdminHome(segue: UIStoryboardSegue){
        
    }
    
    func setupSideMenu() {
        // Define the menus
        SideMenuManager.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "rightMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuAnimationTransformScaleFactor = 1
        SideMenuManager.menuAnimationFadeStrength = 0.77
        SideMenuManager.menuFadeStatusBar = false
    }
    
    func setupBorders() {
        realTimeView.layer.borderWidth = 1
        realTimeView.layer.borderColor = UIColor.darkGray.cgColor
        realTimeView.layer.cornerRadius = 10
        WorkstationView.layer.borderWidth = 1
        WorkstationView.layer.borderColor = UIColor.darkGray.cgColor
        WorkstationView.layer.cornerRadius = 10
        dashboardView.layer.borderWidth = 1
        dashboardView.layer.borderColor = UIColor.darkGray.cgColor
        dashboardView.layer.cornerRadius = 10
    }
}
