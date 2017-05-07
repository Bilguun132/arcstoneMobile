//
//  ShowJobViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 20/12/16.
//  Copyright © 2016 Bilguun. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import SideMenu

class ShowJobViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populate_view()
        setupSideMenu()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Variables
    
    @IBOutlet weak var job_text: UILabel!
    @IBOutlet weak var batch_template: UITextField!
    @IBOutlet weak var sales_name: UITextField!
    @IBOutlet weak var scheduled_date_text: UITextField!
    @IBOutlet weak var completion_date_text: UITextField!
    @IBOutlet weak var image_view: UIImageView!
    @IBOutlet weak var notes: UITextView!
    
    
    var index_json_data:JSON = ""
    var batchRun: BatchRun?
    var batch_template_id = ""
    var batch_run_id = ""
    var batch_template_step_json:JSON = ""
    var batch_run_step_json:JSON = ""
    var batchRunStepList: [BatchRunStep]?
    
    //MARK: - User Functions
    
    func populate_view(){
        
        job_text.text = batchRun?.name
        batch_template.text = batchRun?.templateName
        sales_name.text = batchRun?.salesName
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if batchRun?.scheduledStartDateTime != "" {
            scheduled_date_text.text = dateFormatter.string(from: dateFormatterGet.date(from: (batchRun?.scheduledStartDateTime.substring(to: 19))!)!)
        }
        if batchRun?.lastUpdate != "" {
            completion_date_text.text = dateFormatter.string(from: dateFormatterGet.date(from: (batchRun?.lastUpdate.substring(to: 19))!)!)
        }
        batch_template_id = String(describing: batchRun!.batchTemplateId)
        batch_run_id = String(describing: batchRun!.id)
        notes.text = batchRun?.note
    }
    func setupSideMenu() {
        // Define the menus
        SideMenuManager.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "rightMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuAnimationTransformScaleFactor = 1
        SideMenuManager.menuAnimationFadeStrength = 0.77
        SideMenuManager.menuFadeStatusBar = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_steps" {
            let display_controller = segue.destination as! AvailableJobsViewController
            display_controller.batch_template_step_json = self.batch_template_step_json
            display_controller.batch_run_step_json = self.batch_run_step_json
            display_controller.batchRunStepList = self.batchRunStepList
            display_controller.batch_run_id = self.batch_run_id
            display_controller.batch_run_name = (batchRun?.name)!
        }
    }
    
    @IBAction func batch_button_pressed(_ sender: Any) {
        SVProgressHUD.show()
        DataController.getData(api_string: DataController.Routes.getBatchRunStepByBatchRunId+(self.batch_run_id)) {response in
            self.batchRunStepList = BatchRunStepMap.BatchRunStepMap(BatchStepListJson: response["batchRunStepList"])
            self.performSegue(withIdentifier: "show_steps", sender: self)
        }
    }
}

//MARK: - String Extensions

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}
