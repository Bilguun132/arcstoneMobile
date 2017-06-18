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
    
    //MARK: - HTTP GET
    
    static func getData(api_string:String, completion: @escaping (JSON) -> ()) {
        if UserDefaults.standard.string(forKey: "Server") == nil {
            EZAlertController.alert("Alert", message: "Server address not set")
            SVProgressHUD.dismiss()
            return
        }
        var value : JSON = ""
        let server = ("https://" + "\(UserDefaults.standard.string(forKey: "Server")!)" + "/\(UserDefaults.standard.string(forKey: "Route")!)/")
        let headers: HTTPHeaders = ["Authorization" : UserDefaults.standard.string(forKey: "Token")!]
        print(server+api_string)
        Alamofire.request(server + api_string, headers: headers).validate().responseJSON { response in
            switch response.result {
            case.success(let json_value):
                value = JSON(json_value)
                completion(value)
            case.failure (let error):
                SVProgressHUD.dismiss()
                switch error._code {
                case Error.Internet_is_offline.rawValue:
                    print("Time out")
                default:
                    print(error)
                    
                }
            }
        }
    }
    
    //MARK: - HTTP POST
    
    static func postData(api_string:String, post_message: [String:Any], completion: @escaping (JSON) -> ()) {
        if UserDefaults.standard.string(forKey: "Server") == nil {
            EZAlertController.alert("Alert", message: "Server address not set")
            SVProgressHUD.dismiss()
            return
        }
        let url = "https://" + "\(UserDefaults.standard.string(forKey: "Server")!)" + "/\(UserDefaults.standard.string(forKey: "Route")!)/" + api_string
        let headers: HTTPHeaders = ["Authorization" : UserDefaults.standard.string(forKey: "Token")!]
        Alamofire.request(url, method:.post, parameters:post_message, encoding:URLEncoding.default, headers: headers).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let json_value):
                let value = JSON(json_value)
                completion(value)
            case .failure(let error):
                print(error._code)
                switch error._code {
                case Error.Internet_is_offline.rawValue:
                    print("Time out")
                default:
                    print(error)
                }
                print(error)
                let value:JSON = ["Error": error._code]
                completion(value)
            }
        }
    }
    
    static func login(api_string:String, post_message: [String:Any], completion: @escaping (JSON) -> ()) {
        if UserDefaults.standard.string(forKey: "Server") == nil {
            EZAlertController.alert("Alert", message: "Server address not set")
            SVProgressHUD.dismiss()
            return
        }
        let url = "https://" + "\(UserDefaults.standard.string(forKey: "Server")!)" + "/\(UserDefaults.standard.string(forKey: "Route")!)/" + api_string
        Alamofire.request(url, method:.post, parameters:post_message, encoding:URLEncoding.default).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let json_value):
                let value = JSON(json_value)
                completion(value)
            case .failure(let error):
                print(error._code)
                switch error._code {
                case Error.Internet_is_offline.rawValue:
                    print("Time out")
                default:
                    print(error)
                }
                print(error)
                let value:JSON = ["Error": error._code]
                completion(value)
            }
        }
    }
    
    //MARK: - Support functions
    
    static func getQRImage(qrString:String) -> (CIImage) {
        let data = qrString.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        return (filter?.outputImage)!
    }
    
    //MARK: - Enums, Constants
    
    static func convert_batch_run_step_status(number:String) -> (String, UIColor?) {
        switch number {
        case "0" :
            return ("Nothing Set", UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1))
        case "1":
            return ("Queued", UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1))
        case "2":
            return ("Ready", UIColor.init(red: 240/255, green: 234/255, blue: 249/255, alpha: 1))
        case "3":
            return ("Running", UIColor.init(red: 222/255, green: 246/255, blue: 226/255, alpha: 1))
        case "4":
            return ("Next in line", UIColor.yellow)
        case "5":
            return ("Done", UIColor.init(red: 191/255, green: 230/255, blue: 245/255, alpha: 1))
        case "6":
            return ("Paused", UIColor.init(red: 245/255, green: 243/255, blue: 215/255, alpha: 1))
        case "7":
            return ("Delayed", UIColor.init(red: 243/255, green: 208/255, blue: 204/255, alpha: 1))
        case "8":
            return ("Unassigned", UIColor.yellow)
        case "9":
            return ("No Template", UIColor.gray)
        case "10":
            return ("Cancelled", UIColor.init(red: 250/255, green: 244/255, blue: 240/255, alpha: 1))
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
    
    
    enum Error:Int {
        case Internet_is_offline = -1009
    }
    
    struct Variables {
        static var personnel_name = "Test Personnel"
    }
    
    enum Constants {
        case Queued, Ready, Running, Next_in_line, Done, Paused, Delayed, Unassigned, Cancelled, Item_Scrapped
    }
    
    enum dashboardType: Int {
        case Text = 0
        case Picture = 1
        case Gauges = 2
        case Charts = 3
    }
    
    enum GaugeType: Int {
        case FullCircle = 0
        case HalfCircle = 1
        case QuarterLeftCircle = 2
        case QuarterRightCircle = 3
        case HorizontalBar = 4
        case VerticalBar = 5
        case Digital = 6
        case StateIndicator = 7
    }
    
    //MARK: - Routes
    struct Routes {
        //MARK: - Personnel
        static let validatePersonnelLogin = "api/login"
        static let getAllPersonnel = "api/personnels"
        static let getPersonnelById = "api/personnels/"
        //MARK: - Batch Run
        static let getAllBatchRunList = "api/batchRuns"
        static let getBatchRunListById = "api/batchRuns/"
        static let getBatchRunListByPersonnelId = "api/batchRuns/personnel/"
        static let getBatchRunHistoryByPersonnelId = "api/batchRuns/personnelHistory/"
        static let getBatchRunHistoryByEquipmentId = "api/batchRuns/equipmentHistory/"
        //MARK: - Batch Run Step
        static let getAllBatchRunSteps = "api/batchRunSteps"
        static let getBatchRunStepsById = "api/batchRunSteps/"
        static let getBatchRunStepByBatchRunId = "api/batchRunSteps/byBatchRunId/"
        static let getBatchRunStepsByPersonnelId = "api/batchRunSteps/byPersonnelId/"
        static let getBatchRunStepByFacilityId = "api/batchRunSteps/ByFacilityAssetId/"
        static let stopBatchRunStep = "api/batchRunSteps/stop"
        static let pauseBatchRunStep = "api/batchRunSteps/pause"
        static let startBatchRunStep = "api/batchRunSteps/start"
        //MARK: - BatchRunStepParameter
        static let getAllBatchRunStepParameters = "api/batchRunStepParameters"
        static let getAllBatchRunStepParametersByBatchRunStepId = "api/batchRunStepParameters/batchRunStepId/"
        static let updateBatchRunStepParameter = "api/batchRunStepParameters/updateBatchRunStepParameter"
        //MARK: - Facility
        static let getAllFacility = "api/facilities"
        static let getAllFacilityAsset = "api/facilityAssets"
        static let getAllFacilityAssetByBatchRunId = "api/facilityAssets/byBatchRunId/"
        //MARK: - Dashboard
        static let getAllDashboardElements = "api/dashboardElements"
        static let getDashboardElementsbyId = "api/dashboardElements/"
        static let getAllDashboard = "api/dashboard"
        static let getDashboard = "api/dashboard/"
        static let getCurrentValue = "api/dashboardElements/currentValue/"
        
        
    }
    
}
