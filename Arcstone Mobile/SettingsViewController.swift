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
    @IBOutlet weak var current_server: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if   UserDefaults.standard.string(forKey: "Server") != nil {
            current_server.text = UserDefaults.standard.string(forKey: "Server")
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
            UserDefaults.standard.setValue(server_address.text!, forKey: "Server")
            EZAlertController.alert("Success", message: "New Server Address is set", acceptMessage: "Ok", acceptBlock: {
                _ = self.navigationController?.popViewController(animated: true)
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
