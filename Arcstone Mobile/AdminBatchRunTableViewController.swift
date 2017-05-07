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
    
    //MARK: - Variables
    @IBOutlet weak var tableView: UITableView!
    var BatchRunList: [BatchRun]?
    var batchRun: BatchRun?
    var batch_info:[[String:Any]] = [[:]]
    var filteredData: [BatchRun]?
    var searchController: UISearchController!
    var job_json_data: JSON = ""
    var batch_run_list: JSON = []
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        filteredData = BatchRunList
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
        return filteredData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BatchRunCell
        let dict = filteredData?[indexPath.row]
        cell.name.text = dict?.name
        if dict?.startDateTime != "" {
            cell.start_time.text = dict?.startDateTime
        }
        else {
            cell.start_time.text = "Have not started yet"
            cell.end_time.text = ""
        }
        if cell.start_time.text != "Have not started yet" {
            if dict?.endDateTime != "" {
                cell.end_time.text = dict?.endDateTime
            }
            else {
                cell.end_time.text = "Still running"
            }
        }
        //gets the status and assigns an appropriate image
        switch (dict?.status)!{
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.batchRun = filteredData?[indexPath.row]
        self.performSegue(withIdentifier: "show_jobs_detail", sender: self)
    }
    
    //MARK:
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_jobs_detail" {
            let display_controller = segue.destination as! ShowJobViewController
            display_controller.batchRun = self.batchRun
        }
    }
    //populates the table view with search criteria
    func updateSearchResults(for searchController: UISearchController) {
        var temp: [BatchRun] = []
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty == false {
                for batchRun: BatchRun in BatchRunList! {
                    if batchRun.name.lowercased().contains(searchText.lowercased()){
                        temp.append(batchRun)
                    }
                }
                filteredData = temp
            }
            else {
                filteredData = BatchRunList
            }
            tableView.reloadData()
        }
    }
    
    //MARK: - User Functions
    
    func setupSideMenu() {
        // Define the menus
        SideMenuManager.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "rightMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuAnimationTransformScaleFactor = 1
        SideMenuManager.menuAnimationFadeStrength = 0.77
        SideMenuManager.menuFadeStatusBar = false
    }
    
    func setup(){
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchController.hidesNavigationBarDuringPresentation = false
        //        self.navigationItem.titleView = searchController.searchBar
        tableView.tableHeaderView = searchController.searchBar
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        
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

