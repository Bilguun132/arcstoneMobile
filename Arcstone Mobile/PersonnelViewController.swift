//
//  PersonnelViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 22/1/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import SideMenu

class personCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var batch_run_name: UILabel!
    @IBOutlet weak var work_status: UILabel!
    
}


class PersonnelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    //MARK: - Variables
    
    var personnelList:JSON = ""
    var searchController: UISearchController!
    var filteredData: JSON = ""
    var personnel_id = ""
    var personnelHistory:JSON = ""
    
    
    @IBOutlet weak var batch_run_name: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        setup_search_bar()
        setupSideMenu()
        print(filteredData)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! personCell
        var dict = filteredData[indexPath.row]
        cell.name.text = dict["First_name"].stringValue
        
        if (dict["batch_run"].stringValue != "") {
            cell.batch_run_name.text = "Working on " + dict["batch_run"].stringValue
        }
        else {
            cell.batch_run_name.text = "Idle"
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
        personnel_id = filteredData[indexPath.row]["Id"].stringValue
        DataController.getData(api_string: "api/Batchrun/BatchrunListHistoryByPersonnelID?personnelID=" + self.personnel_id) {response in
            self.personnelHistory = response["BatchrunHeaderList"]
            self.performSegue(withIdentifier: "show_personnel_jobs_history", sender: self)
        }
    }
    //MARK:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_personnel_jobs_history" {
            let display_controller = segue.destination as! AdminBatchRunViewController
            display_controller.batch_run_list = self.personnelHistory
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        var temp = [[String:Any]]()
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty == false {
                filteredData = ""
                for (_,subJson):(String, JSON) in personnelList {
                    if subJson["First_name"].stringValue.lowercased().contains(searchText.lowercased()){
                        temp.append(subJson.dictionaryObject!)
                    }
                }
                filteredData = JSON(temp)
            }
            else {
                filteredData = personnelList
            }
            tableView.reloadData()
        }
    }
    
    //MARK: - User Functions
    func setup_search_bar(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        filteredData = personnelList
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
