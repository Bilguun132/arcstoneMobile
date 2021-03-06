//
//  EquipmentTableViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 17/12/16.
//  Copyright © 2016 Bilguun. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import SideMenu

class BatchRunListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        table.register(UINib(nibName: "BatchRunTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        //        self.navigationItem.setHidesBackButton(true, animated: false)
        SVProgressHUD.dismiss()
        check_if_empty()
        setupSideMenu()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Variables
    
    @IBOutlet var table: UITableView!
    var batch_run_list_json_by_personnelID : JSON = ""
    var personnel_id = ""
    var job_json_data:JSON = ""
    var user: Personnel?
    
    
    
    // MARK: - Table view functions
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return batch_run_list_json_by_personnelID.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BatchRunCell
        var dict = batch_run_list_json_by_personnelID[indexPath.row]
        cell.name.text = dict["Name"].stringValue
        if dict["Start_date_time"].stringValue != "" {
            cell.start_time.text = dict["Start_date_time"].stringValue
        }
        else {
            cell.start_time.text = "Have not started yet"
            cell.end_time.text = ""
        }
        if cell.start_time.text != "Have not started yet" {
            if dict["End_date_time"].stringValue != "" {
                cell.end_time.text = dict["End_date_time"].stringValue
            }
            else {
                cell.end_time.text = "Still running"
            }
        }
        
        switch dict["Status"].intValue {
        case 5:
            cell.statusImage.image = #imageLiteral(resourceName: "Checked Checkbox 2_100")
        case 10:
            cell.statusImage.image = #imageLiteral(resourceName: "Shutdown_100")
        case 6:
            cell.statusImage.image = #imageLiteral(resourceName: "Pause_100")
        case 1:
            cell.statusImage.image = #imageLiteral(resourceName: "Restart_100")
        case 7:
            cell.statusImage.image = #imageLiteral(resourceName: "High Priority_100")
        case 3:
            cell.statusImage.image = #imageLiteral(resourceName: "In Progress_100")
        default:
            print("Normal")
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.job_json_data = batch_run_list_json_by_personnelID[indexPath.row]
        self.performSegue(withIdentifier: "show_jobs_detail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_jobs_detail" {
            let display_controller = segue.destination as! ShowJobViewController
            display_controller.index_json_data = job_json_data
        }
    }
    
    //MARK: - Support Functions
    
    
    @IBAction func logout_button(_ sender: Any) {
        UserDefaults.standard.setValue("nil", forKey: "PersonnelID")
        self.performSegue(withIdentifier: "back_to_login", sender: self)
    }
    
    func check_if_empty(){
        if batch_run_list_json_by_personnelID.count == 0 {
            EZAlertController.alert("Alert", message: "No jobs are available")
        }
    }
    
    func makeAttributedString(title: String) -> NSAttributedString {
        let titleAttributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .title1), NSForegroundColorAttributeName: UIColor.darkGray]
        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
        return titleString
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
