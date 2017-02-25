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
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
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
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuAnimationTransformScaleFactor = 1
        SideMenuManager.menuAnimationFadeStrength = 0.77
        SideMenuManager.menuFadeStatusBar = false
    }
    
    func setupBorders() {
        view1.layer.borderWidth = 1
        view1.layer.borderColor = UIColor.darkGray.cgColor
        view1.layer.cornerRadius = 10
        view2.layer.borderWidth = 1
        view2.layer.borderColor = UIColor.darkGray.cgColor
        view2.layer.cornerRadius = 10
    }
}
