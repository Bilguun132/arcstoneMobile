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
    @IBOutlet weak var route_address: UITextField!
    @IBOutlet weak var dashboardWebAddress: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if   UserDefaults.standard.string(forKey: "Server") != nil {
            server_address.placeholder = UserDefaults.standard.string(forKey: "Server")
        }
        if UserDefaults.standard.string(forKey: "Route") != nil {
            route_address.placeholder = UserDefaults.standard.string(forKey: "Route")
        }
        if UserDefaults.standard.string(forKey: "DashboardAddress") != nil {
            dashboardWebAddress.placeholder = UserDefaults.standard.string(forKey: "DashboardAddress")
        }
        //        setupSideMenu()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func showDefaultRoute(_ sender: Any) {
        EZAlertController.alert("Route", message: UserDefaults.standard.string(forKey: "Route")!)
    }
    
    @IBAction func submitButton(_ sender: Any) {
        if server_address.text == "" && route_address.text == "" {
            EZAlertController.alert("Alert", message: "Server Address cannot be empty")
        }
        else {
            if route_address.text != "" {
                UserDefaults.standard.setValue(route_address.text, forKey: "Route")
            }
            if server_address.text != "" {
                UserDefaults.standard.setValue(server_address.text!, forKey: "Server")
            }
            EZAlertController.alert("Success", message: "New Server Address is set", acceptMessage: "Ok", acceptBlock: {
                UserDefaults.standard.set("nil", forKey: "PersonnelID")
                _ = self.navigationController?.popToRootViewController(animated: true)
            })
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
