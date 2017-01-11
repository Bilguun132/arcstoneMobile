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

class BatchRunListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        table.register(UINib(nibName: "BatchRunTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "Available Jobs"
        SVProgressHUD.dismiss()
        
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
    

    
    // MARK: - Table view functions
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return batch_run_list_json_by_personnelID["BatchrunHeaderList"].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var dict = batch_run_list_json_by_personnelID["BatchrunHeaderList"][indexPath.row]
        cell.textLabel?.attributedText = makeAttributedString(title: dict["Name"].stringValue)
        let status = DataController.convert_batch_run_step_status(number: dict["Status"].stringValue)
        cell.detailTextLabel?.text = status.0
        cell.backgroundColor = status.1
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.job_json_data = batch_run_list_json_by_personnelID["BatchrunHeaderList"][indexPath.row]
        self.performSegue(withIdentifier: "show_jobs_detail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_jobs_detail" {
            let display_controller = segue.destination as! ShowJobViewController
            display_controller.index_json_data = job_json_data
        }
    }
    
    //MARK: - Support Functions
    
    func makeAttributedString(title: String) -> NSAttributedString {
        let titleAttributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .title1), NSForegroundColorAttributeName: UIColor.darkGray]
        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
        return titleString
    }
    
    
}
