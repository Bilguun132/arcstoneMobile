//
//  BatchRunStepParameterInfoViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 7/1/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import Alamofire
import SideMenu

class BatchRunStepParameterInfoViewController: UIViewController, UITextViewDelegate {
    
    var batch_run_para_id = 0
    var batchRunStepParameter: batchRunStepParameter?
    var oldActualValue = ""
    
    @IBOutlet weak var para_name: UITextField!
    @IBOutlet weak var expected_value: UITextField!
    @IBOutlet weak var actual_value: UITextField!
    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var notes_textview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        self.navigationItem.title = "Parameters"
        populate()
        setupSideMenu()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        notes_textview.sizeToFit()
    }
    
    
    @IBAction func update_para_button_clicked(_ sender: Any) {
        if oldActualValue != actual_value.text{
            if actual_value.text != "" {
                let message = ["id" : batchRunStepParameter!.id, "value" : actual_value!.text!] as [String : Any]
                batchRunStepParameter!.actualValue = actual_value.text!
                print(message)
                DataController.postData(api_string: DataController.Routes.updateBatchRunStepParameter, post_message : message) {response in
                }
            }
        }
    }
    
    func populate(){
        para_name.text = batchRunStepParameter?.name
        expected_value.text = batchRunStepParameter?.expectedValue
        actual_value.text = batchRunStepParameter?.actualValue
        notes_textview.text = batchRunStepParameter?.templateNotes
    }
    
    func setupSideMenu() {
        // Define the menus
        SideMenuManager.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "rightMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuAnimationTransformScaleFactor = 1
        SideMenuManager.menuAnimationFadeStrength = 0.77
        SideMenuManager.menuFadeStatusBar = false
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
