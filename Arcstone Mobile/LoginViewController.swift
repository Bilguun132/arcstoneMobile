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

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Variables
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var log_in_button: UIButton!
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
        navigationController!.interactivePopGestureRecognizer?.delegate = self
        self.view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        SVProgressHUD.dismiss()
        print(UserDefaults.standard.string(forKey: "Server") ?? "not set" )
        if UserDefaults.standard.string(forKey: "Server") != nil {
            show_login_info()
        }
        else {
            show_server_info()
        }
        set_alert_strings()
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
        }
    }
    
    //MARK: - User Functions
    
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
    
    func show_login_info() {
        username.alpha = 1
        password.alpha = 1
        log_in_button.alpha = 1
        server_text.alpha = 0
        set_server_button.alpha = 0
    }
    
    func show_server_info() {
        username.alpha = 0
        password.alpha = 0
        log_in_button.alpha = 0
        server_text.alpha = 1
        set_server_button.alpha = 1
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
            let RootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "root") as! NavigationStack
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = RootViewController
        }
    }
    
    @IBAction func log_in_button_pressed(_ sender: Any) {
        if username.text == "" || password.text == "" {
            SVProgressHUD.dismiss()
            EZAlertController.alert(UserDefaults.standard.string(forKey: "Alert_localization")!, message: "Authentication fail. Please try again")
            return
        }
        SVProgressHUD.show()
        DataController.getData(api_string: "api/Personnel/AuthenticateUser?username="+(username.text)!+"&lastname="+(password.text)!) {response in
            print(response)
            if response["ResponseCode"].stringValue == "0" {
                SVProgressHUD.dismiss()
                EZAlertController.alert("No such user", message: "Please chech your username or password")
                self.clear_fields()
                return
            }
            if response["ResponseCode"].stringValue == "1" {
                self.view.endEditing(true)
                SVProgressHUD.dismiss()
                print(response["PersonnelHeaderList"]["Id"])
                self.personnel_info_id = response["PersonnelHeaderList"][0]["Id"].stringValue
                print(self.personnel_info_id)
                UserDefaults.standard.setValue(self.personnel_info_id, forKey: "PersonnelID")
                EZAlertController.alert(UserDefaults.standard.string(forKey: "Success_localization")!, message: self.authenticated_string, acceptMessage: "Ok", acceptBlock: {
                    SVProgressHUD.show()
                    if self.username.text == "admin" {
                        self.performSegue(withIdentifier: "admin_login_segue", sender: self)
                        return
                    }
                    DataController.getData(api_string: "api/Batchrun/BatchrunListByPersonnelID?personnelID="+(self.personnel_info_id)) {response in
                        self.batch_run_list_json_by_personnelID = response
                        self.performSegue(withIdentifier: "login_segue", sender: self)
                        return
                    }
                })
            }
        }
    }
}

//MARK: - Navigation Controller Extension

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if navigationController?.viewControllers.count == 2 {
            return true
        }
        
        if let navigationController = self.navigationController as? NavigationStack {
            navigationController.showControllers()
        }
        
        return false
    }
}

