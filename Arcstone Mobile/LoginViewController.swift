//
//  ViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 17/12/16.
//  Copyright © 2016 Bilguun. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SideMenu

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Variables
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var server_text: UITextField!
    @IBOutlet weak var set_server_button: UIButton!
    var personnel_info_id = ""
    var batch_run_list_json_by_personnelID : JSON = ""
    var authenticated_string = ""
    
    //MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()        // Do any additional setup after loading the view, typically from a nib.
        self.username.delegate = self
        self.password.delegate = self
        self.view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        SVProgressHUD.dismiss()
        set_alert_strings()
        setupSideMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if (UserDefaults.standard.string(forKey: "PersonnelID")) != "nil" {
            performSegue(withIdentifier: "login_segue", sender: self)
        }
        let langStr = Locale.current.languageCode
        print(langStr!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login_segue" {
            let display_controller = segue.destination as! BatchRunListViewController
            display_controller.batch_run_list_json_by_personnelID = self.batch_run_list_json_by_personnelID
            display_controller.personnel_id = self.personnel_info_id
            display_controller.self.navigationItem.setHidesBackButton(true, animated: false)
        }
        if segue.identifier == "admin_login_segue" {
            let display_controller = segue.destination as! AdminViewController
            display_controller.personnel_info_id = self.personnel_info_id
            display_controller.self.navigationItem.setHidesBackButton(true, animated: false)
        }
    }
    
    //MARK: - User Functions
    
    func form_login_message()->[String:Any]{
        let username = self.username.text
        let password = self.password.text
        let message = ["User_name" : username, "First_name" : password]
        return message
    }
    
    func clear_fields() {
        username.text = ""
        password.text = ""
    }
    
    func set_alert_strings(){
        if Locale.current.languageCode == "en"{
            UserDefaults.standard.setValue("Success", forKey: "Success_localization")
            UserDefaults.standard.setValue("Alert", forKey: "Alert_localization")
            authenticated_string = "Authenticated"
        }
        else{
            UserDefaults.standard.setValue("很好", forKey: "Success_localization")
            UserDefaults.standard.setValue("警报", forKey: "Alert_localization")
            authenticated_string = "验证"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
    
    func setupSideMenu() {
        // Define the menus
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuAnimationTransformScaleFactor = 1
        SideMenuManager.menuAnimationFadeStrength = 0.77
        SideMenuManager.menuFadeStatusBar = false
    }
    
    //MARK: - Buttons
    
    @IBAction func switch_lang_button(_ sender: Any) {
        
    }
    
    
    @IBAction func set_button_pressed(_ sender: Any) {
        if server_text.text == "" {
            EZAlertController.alert(UserDefaults.standard.string(forKey: "Alert_localization")!, message: "Please enter server address")
        }
        else {
            UserDefaults.standard.setValue(server_text.text, forKey: "Server")
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let RootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "root") as! UINavigationController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = RootViewController
        }
    }
    
    
    @IBAction func open_link_button(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "http://arcstoneincorporated.com")!)
    }
    
    @IBAction func log_in_button_pressed(_ sender: Any) {
        if username.text == "" || password.text == "" {
            SVProgressHUD.dismiss()
            EZAlertController.alert(UserDefaults.standard.string(forKey: "Alert_localization")!, message: "Username or password field is empty")
            return
        }
        SVProgressHUD.show()
        //        DataController.getData(api_string: "api/Personnel/AuthenticateUser?username="+(username.text)!+"&lastname="+(password.text)!) {response in
        DataController.postData(api_string: "api/Personnel/Validate_Personnel_Login", post_message: form_login_message()) {response in
            if response["PersonnelHeaderList"].count == 0 {
                SVProgressHUD.dismiss()
                EZAlertController.alert("No such user", message: "Please check your username or password")
                self.clear_fields()
                return
            }
            if response["PersonnelHeaderList"].count != 0 {
                self.view.endEditing(true)
                SVProgressHUD.dismiss()
                self.personnel_info_id = response["PersonnelHeaderList"][0]["Id"].stringValue
                UserDefaults.standard.setValue(self.personnel_info_id, forKey: "PersonnelID")
                SVProgressHUD.show()
                DataController.Variables.personnel_name = response["PersonnelHeaderList"][0]["First_name"].stringValue
                if response["PersonnelHeaderList"][0]["position"].stringValue == "admin" {
                    self.performSegue(withIdentifier: "admin_login_segue", sender: self)
                    return
                }
                DataController.getData(api_string: "api/Batchrun/BatchrunListByPersonnelID?personnelID="+(self.personnel_info_id)) {response in
                    self.batch_run_list_json_by_personnelID = response["BatchrunHeaderList"]
                    self.performSegue(withIdentifier: "login_segue", sender: self)
                    return
                }
            }
        }
    }
}

