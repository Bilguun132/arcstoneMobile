//
//  MachinesViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 30/1/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import SideMenu

class machineCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var step_name: UILabel!
}

class MachinesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var machine_list:JSON = ""
    var searchController: UISearchController!
    var filteredData: JSON = ""
    var machine_id = ""
    var machine_history:JSON = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        setup_search_bar()
        setupSideMenu()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! machineCell
        var dict = filteredData[indexPath.row]
        cell.name.text = dict["Name"].stringValue
        cell.step_name.text = dict["BatchStep"].stringValue
        if dict["Is_busy"].stringValue == "true" {
            //            cell.backgroundColor = UIColor.init(red: 0.97, green: 0.71, blue: 0.71, alpha: 1)
            if cell.step_name.text == "" {
                cell.status.text = "In Use"
            }
            else {
                cell.status.text = "Used on"
            }
        }
        else {
            cell.status.text = "Idle"
            //            cell.backgroundColor = UIColor.green
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
        machine_id = filteredData[indexPath.row]["Id"].stringValue
        DataController.getData(api_string: "api/Batchrun/BatchrunListHistoryByEquipmentID?facilityID=" + self.machine_id) {response in
            self.machine_history = response["BatchrunHeaderList"]
            self.performSegue(withIdentifier: "show_machine_jobs_history", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_machine_jobs_history" {
            let display_controller = segue.destination as! AdminBatchRunViewController
            display_controller.batch_run_list = self.machine_history
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        var temp = [[String:Any]]()
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty == false {
                filteredData = ""
                for (_,subJson):(String, JSON) in machine_list {
                    if subJson["Name"].stringValue.lowercased().contains(searchText.lowercased()){
                        temp.append(subJson.dictionaryObject!)
                    }
                }
                filteredData = JSON(temp)
            }
            else {
                filteredData = machine_list
            }
            tableView.reloadData()
        }
    }
    
    func setup_search_bar(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        filteredData = machine_list
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
