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
    
    var searchController: UISearchController!
    var filteredData: [Personnel]?
    var personnel_id = ""
    var batchRunHistoryByPersonnel: [BatchRun]?
    var personnelList: [Personnel]?
    
    
    @IBOutlet weak var batch_run_name: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        filteredData = personnelList
        setup_search_bar()
        setupSideMenu()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! personCell
        let dict = filteredData?[indexPath.row]
        cell.name.text = dict?.firstName
        
        if (dict?.isAvailable == false) {
            cell.batch_run_name.text = "Busy"
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
        personnel_id = String(describing: filteredData![indexPath.row].id)
        DataController.getData(api_string: DataController.Routes.getBatchRunHistoryByPersonnelId + self.personnel_id) {response in
            self.batchRunHistoryByPersonnel = BatchRunMap.mapBatchRuns(batchRunListJson: response["batchRunList"])
            self.performSegue(withIdentifier: "show_personnel_jobs_history", sender: self)
        }
    }
    //MARK:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_personnel_jobs_history" {
            let display_controller = segue.destination as! AdminBatchRunViewController
            display_controller.BatchRunList = self.batchRunHistoryByPersonnel
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        var temp: [Personnel] = []
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty == false {
                for personnel: Personnel in personnelList! {
                    if personnel.firstName.lowercased().contains(searchText.lowercased()){
                        temp.append(personnel)
                    }
                }
                filteredData = temp
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
