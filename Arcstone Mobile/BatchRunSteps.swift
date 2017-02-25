//
//  AvailableJobsViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 21/12/16.
//  Copyright © 2016 Bilguun. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import SideMenu

class AvailableJobsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = batch_run_name
        SVProgressHUD.dismiss()
        batch_run_id = batch_run_step_json[0]["Batch_run_id"].stringValue
        print(batch_run_step_json)
        setupSideMenu()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: (247/255), green: (247/255), blue: (247/255), alpha: 1)
        DataController.getData(api_string: "api/Batchrunstep/BatchrunstepListByBatchRunID?batchrunID="+(self.batch_run_id)) {response in
            self.batch_run_step_json = response["BatchrunstepHeaderList"]
            self.table.reloadData()
        }
    }
    
    //MARK: - Variables
    
    @IBOutlet weak var table: UITableView!
    var batch_template_step_json:JSON = ""
    var batch_run_step_json:JSON = ""
    var selected_table_index = 0
    var status = ""
    var batch_run_id = ""
    var batch_run_name = ""
    
    // MARK: - Table view functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return batch_run_step_json.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var run_dict = batch_run_step_json[indexPath.row]
        let status = DataController.convert_batch_run_step_status(number: run_dict["Status"].stringValue)
        self.status = status.0
        cell.textLabel?.text = run_dict["Name"].stringValue
        cell.detailTextLabel?.text = status.0
        cell.backgroundColor = status.1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        self.selected_table_index = indexPath!.row
        self.status = (currentCell.detailTextLabel?.text)!
        self.performSegue(withIdentifier: "run_status_segue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "run_status_segue"  {
            let display_controller = segue.destination as! BatchRunStatusViewController
            display_controller.run_step_info = batch_run_step_json[selected_table_index]
            display_controller.current_status = self.batch_run_step_json[selected_table_index]["Status"].stringValue
            display_controller.batch_run_id = self.batch_run_id
            display_controller.batch_step_name = self.batch_run_step_json[selected_table_index]["Name"].stringValue
            display_controller.batch_run_name = self.batch_run_name
        }
    }
    
    func setupSideMenu() {
        // Define the menus
        SideMenuManager.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "rightMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuAnimationTransformScaleFactor = 1
        SideMenuManager.menuAnimationFadeStrength = 0.77
        SideMenuManager.menuFadeStatusBar = false
    }
}
