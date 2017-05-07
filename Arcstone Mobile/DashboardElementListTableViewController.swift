//
//  DashboardListTableViewController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 14/4/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import UIKit
import SVProgressHUD

class DashboardElementListTableViewController: UITableViewController, UISearchResultsUpdating {
    
    //MARK: - Variables
    var dashboardList: [DashboardElement]?
    var dashboard: DashboardElement?
    var filteredData: [DashboardElement]?
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        SVProgressHUD.dismiss()
        ShinobiGauges.setLicenseKey("mUF8CpmUhUafZwoMjAxNzA1MDliaWxndXVuLmJhdGJvbGRAYXJjc3RvbmVpbmNvcnBvcmF0ZWQuY29tMNQAi7+lDE0ch+EOhf5yh6XpdXlLKA+3H5z6uMeStpMYS68F++rSzbVJo2tffSEuZiLTyiTe/UxsM1Bi5ZcYLMSkiwXg25GEdLJUWEuGYZG/UzixEhqDf1DV3xd0lAmMvwaXLdrSqcSLk3EV+fx0/QHkZ4sI=AXR/y+mxbZFM+Bz4HYAHkrZ/ekxdI/4Aa6DClSrE4o73czce7pcia/eHXffSfX9gssIRwBWEPX9e+kKts4mY6zZWsReM+aaVF0BL6G9Vj2249wYEThll6JQdqaKda41AwAbZXwcssavcgnaHc3rxWNBjJDOk6Cd78fr/LwdW8q7gmlj4risUXPJV0h7d21jO1gzaaFCPlp5G8l05UUe2qe7rKbarpjoddMoXrpErC9j8Lm5Oj7XKbmciqAKap+71+9DGNE2sBC+sY4V/arvEthfhk52vzLe3kmSOsvg5q+DQG/W9WbgZTmlMdWHY2B2nbgm3yZB7jFCiXH/KfzyE1A==PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+")
        
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
    
    func setup() {
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
        DataController.getData(api_string: DataController.Routes.getAllDashboardElements) {response in
            self.dashboardList = mapDashboardElement.mapDashboardElementList(dashboardElementListJSON: response["dashboardElementList"])
            self.filteredData = self.dashboardList
            self.tableView.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        var temp: [DashboardElement] = []
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty == false {
                for batchRun: DashboardElement in dashboardList! {
                    if batchRun.name.lowercased().contains(searchText.lowercased()){
                        temp.append(batchRun)
                    }
                }
                filteredData = temp
            }
            else {
                filteredData = dashboardList
            }
            tableView.reloadData()
        }
    }
    
    deinit {
        self.searchController?.view.removeFromSuperview()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredData == nil {
            return 0
        }
        else { return filteredData!.count }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let dict = filteredData?[indexPath.row]
        cell.textLabel?.text = dict!.name
        cell.detailTextLabel?.text = "Status \(String(describing: dict!.status))"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dashboard = filteredData?[indexPath.row]
        self.performSegue(withIdentifier: "show_dashboard", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_dashboard" {
            let display_controller = segue.destination as! GaugeViewController
            display_controller.dashboard = self.dashboard
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
