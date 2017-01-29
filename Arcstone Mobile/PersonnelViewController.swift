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

class personCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
}


class PersonnelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var personnelList:JSON = ""
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        print(personnelList)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return personnelList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! personCell
        var dict = personnelList[indexPath.row]
        cell.name.text = dict["First_name"].stringValue
        return cell
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
