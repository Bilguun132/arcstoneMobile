//
//  SettingsViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 4/2/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import UIKit
import SideMenu

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var server_address: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if   UserDefaults.standard.string(forKey: "Server") != nil {
            server_address.text = UserDefaults.standard.string(forKey: "Server")
        }
        //        setupSideMenu()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submitButton(_ sender: Any) {
        if server_address.text == "" {
            EZAlertController.alert("Alert", message: "Server Address cannot be empty")
        }
        else {
            UserDefaults.standard.setValue(server_address.text, forKey: "Server")
            EZAlertController.alert("Success", message: "New Server Address is set", acceptMessage: "Ok", acceptBlock: {
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    //    func setupSideMenu(){
    //        // Define the menus
    //        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
    //        SideMenuManager.menuPresentMode = .menuSlideIn
    //        SideMenuManager.menuAnimationTransformScaleFactor = 1
    //        SideMenuManager.menuAnimationFadeStrength = 0.77
    //        SideMenuManager.menuFadeStatusBar = false
    //        // Enable gestures. The left and/or right menus must be set up above for these to work.
    //        // Note that these continue to work on the Navigation Controller independent of the view controller it displays!
    //        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
    //        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    //    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
