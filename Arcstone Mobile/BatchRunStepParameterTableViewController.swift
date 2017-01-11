//
//  BatchRunStepParameterTableViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 7/1/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class BatchRunStepParameterTableViewController: UITableViewController {
    var batch_run_step_parameter:JSON = ""
    var individual_batch_run_step_parameter:JSON = ""
    var batch_run_step_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Parameter list"
        SVProgressHUD.dismiss()
        print(batch_run_step_parameter)
        batch_run_step_id = batch_run_step_parameter[0]["Batch_run_step_id"].stringValue
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func viewDidAppear(_ animated: Bool) {
        DataController.getData(api_string: "api/Batchrunstepparameter/BatchrunstepparameterListByBatchRunStepID?param_id="+(self.batch_run_step_id)) {response in
            self.batch_run_step_parameter = response["BatchrunstepparameterHeaderList"]
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return batch_run_step_parameter.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var dict = batch_run_step_parameter[indexPath.row]
        cell.textLabel?.text = dict["Name"].stringValue
        cell.detailTextLabel?.text = dict["Actual_value"].stringValue
        if dict["Actual_value"].stringValue != "" {
            cell.backgroundColor = UIColor.green
        }
        else {
            cell.backgroundColor = UIColor.init(red: 0.97, green: 0.71, blue: 0.71, alpha: 1)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        self.individual_batch_run_step_parameter = batch_run_step_parameter[indexPath.row]
        self.performSegue(withIdentifier: "show_para", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_para" {
            let display_controller = segue.destination as! BatchRunStepParameterInfoViewController
            display_controller.batch_step_parameter_info = individual_batch_run_step_parameter
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
