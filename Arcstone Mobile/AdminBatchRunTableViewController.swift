//
//  AdminBatchRunTableViewController.swift
//
//
//  Created by Bilguun Batbold on 22/1/17.
//
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class BatchRunCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var start_time: UILabel!
    @IBOutlet weak var end_time: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
}

class AdminBatchRunViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    
    @IBOutlet weak var tableView: UITableView!
    var batch_run_list:JSON = ""
    var batch_info:[[String:Any]] = [[:]]
    var filteredData: JSON = ""
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        setup()
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BatchRunCell
        var dict = filteredData[indexPath.row]
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "quick_view_segue", sender: self)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        var temp = [[String:Any]]()
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty == false {
                filteredData = ""
                print(searchText)
                for (_,subJson):(String, JSON) in batch_run_list["BatchrunHeaderList"] {
                    if subJson["Name"].stringValue.lowercased().contains(searchText.lowercased()){
                        print(subJson["Name"])
                        print("Contains")
                        temp.append(subJson.dictionaryObject!)
                    }
                }
                filteredData = JSON(temp)
            }
            else {
                filteredData = batch_run_list["BatchrunHeaderList"]
            }
            tableView.reloadData()
        }
    }
    
    func setup(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        filteredData = batch_run_list["BatchrunHeaderList"]
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

