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
import SideMenu

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
    var job_json_data:JSON = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        setup()
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
        self.job_json_data = filteredData[indexPath.row]
        self.performSegue(withIdentifier: "show_jobs_detail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_jobs_detail" {
            let display_controller = segue.destination as! ShowJobViewController
            display_controller.index_json_data = job_json_data
        }
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        var temp = [[String:Any]]()
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty == false {
                filteredData = ""
                for (_,subJson):(String, JSON) in batch_run_list {
                    if subJson["Name"].stringValue.lowercased().contains(searchText.lowercased()){
                        temp.append(subJson.dictionaryObject!)
                    }
                }
                filteredData = JSON(temp)
            }
            else {
                filteredData = batch_run_list
            }
            tableView.reloadData()
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
    
    func setup(){
        
        if batch_run_list.count == 0 {
            EZAlertController.alert("Alert", message: "Job type is empty")
            return
        }
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        filteredData = batch_run_list
        
    }
    
    deinit {
        self.searchController?.view.removeFromSuperview()
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

