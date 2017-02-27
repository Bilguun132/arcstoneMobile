//
//  QRSettingsViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 26/2/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import UIKit

class QRSettingsViewController: UIViewController {
    
    @IBOutlet weak var prefix: UITextField!
    @IBOutlet weak var batchRunCode: UITextField!
    @IBOutlet weak var batchStepCode: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        if UserDefaults.standard.string(forKey: "QRPrefix") != nil {
            prefix.placeholder = UserDefaults.standard.string(forKey: "QRPrefix")
        }
        if UserDefaults.standard.string(forKey: "QRBatchRunCode") != nil {
            batchRunCode.placeholder = UserDefaults.standard.string(forKey: "QRBatchRunCode")
        }
        if UserDefaults.standard.string(forKey: "QRBatchStepCode") != nil {
            batchStepCode.placeholder = UserDefaults.standard.string(forKey: "QRBatchStepCode")
        }
    }
    
    @IBAction func submitAction(_ sender: Any) {
        if prefix.text != "" {
            UserDefaults.standard.setValue(prefix.text, forKey: "QRPrefix")
        }
        if batchRunCode.text != "" {
            UserDefaults.standard.setValue(batchRunCode.text, forKey: "QRBatchRunCode")
        }
        if batchStepCode.text != "" {
            UserDefaults.standard.setValue(batchStepCode.text, forKey: "QRBatchStepCode")
        }
        _ = navigationController?.popViewController(animated: true)
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
