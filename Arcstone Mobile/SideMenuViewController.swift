//
//  SideMenuViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 4/2/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuViewController: UIViewController {
    
    
    @IBOutlet weak var personnelName: UILabel!
    @IBOutlet weak var home_button: UIButton!
    @IBOutlet weak var username_height: NSLayoutConstraint!
    @IBOutlet weak var home_button_height: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        check_if_logged_in()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        check_if_logged_in()
    }
    
    func check_if_logged_in() {
        print(UserDefaults.standard.string(forKey: "PersonnelID")!)
        if UserDefaults.standard.string(forKey: "PersonnelID") == "nil" {
            personnelName.isHidden = true
            username_height.constant = 0
            home_button_height.constant  = 0
            home_button.isHidden = true
        }
        else {
            personnelName.text = "Welcome, " + DataController.Variables.personnel_name.capitalized
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
