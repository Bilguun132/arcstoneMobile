//
//  DataController.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 17/12/16.
//  Copyright © 2016 Bilguun. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD

class DataController {
    var server_dict = UserDefaults.standard
    //52.77.103.197/UEIOSTestMobileApi/ current server address
    //52.77.103.197/NewMobileApiTest/
    
    //MARK: - HTTP GET
    
    static func getData(api_string:String, completion: @escaping (JSON) -> ()) {
        var value : JSON = ""
        let server = "http://" + "\(UserDefaults.standard.string(forKey: "Server")!)"
                print(server+api_string)
        Alamofire.request(server + api_string).validate().responseJSON { response in
            switch response.result {
            case.success(let json_value):
                value = JSON(json_value)
                completion(value)
            case.failure (let error):
                print(error)
//                EZAlertController.alert("Alert", message: "Incorrect input")
//                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//                let RootViewController = mainStoryBoard.instantiateViewController(withIdentifier: "root") as! NavigationStack
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.window?.rootViewController = RootViewController
            }
        }
    }
    
    //MARK: - HTTP POST
    
    static func postData(api_string:String, post_message: [String:Any], completion: @escaping (JSON) -> ()) {
        let url = "http://" + "\(UserDefaults.standard.string(forKey: "Server")!)" + api_string
        Alamofire.request(url, method:.post, parameters:post_message, encoding:JSONEncoding.prettyPrinted).responseJSON { response in
            switch response.result {
            case .success(let json_value):
                let value = JSON(json_value)
                completion(value)
            case .failure(let error):
                print(error)
                completion("0")
            }
        }
    }
    
    //MARK: - Enums, Constants
    
    static func convert_batch_run_step_status(number:String) -> (String, UIColor?) {
        switch number {
        case "0" :
            return ("Nothing Set", nil)
        case "1":
            return ("Queued", UIColor.yellow)
        case "2":
            return ("Ready", UIColor.green)
        case "3":
            return ("Running", UIColor.init(red: 0.97, green: 0.71, blue: 0.71, alpha: 1))
        case "4":
            return ("Next in line", UIColor.yellow)
        case "5":
            return ("Done", UIColor.green)
        case "6":
            return ("Paused", UIColor.red)
        case "7":
            return ("Delayed", UIColor.red)
        case "8":
            return ("Unassigned", UIColor.yellow)
        case "9":
            return ("No Template", UIColor.gray)
        case "10":
            return ("Cancelled", UIColor.red)
        case "11":
            return ("Pending Raw Material", UIColor.yellow)
        case "12":
            return ("Delayed Unforseen", UIColor.red)
        case "13":
            return ("Forward Material", UIColor.gray)
        case "14":
            return ("Item Completed", UIColor.green)
        case "15":
            return ("Item Scrapped", UIColor.red)
        default:
            return ("not set", UIColor.white)
            
        }
    }
    
    static func conver_status_string_to_enum(status:String) -> String {
        switch status {
        case ("Nothing Set"):
            return "0"
        case ("Queued"):
            return "1"
        case ("Ready"):
            return "2"
        case ("Running"):
            return "3"
        case ("Next in line"):
            return "4"
        case ("Done"):
            return "5"
        case ("Paused"):
            return "6"
        case ("Delayed"):
            return "7"
        default:
            return "2"
        }
    }
    
    struct Constants {
        static let status_names:[String] = ["Queued", "Ready", "Running", "Next in line", "Done", "Paused", "Delayed", "Unassigned", "Cancelled", "Item Scrapped"]
    }
}
