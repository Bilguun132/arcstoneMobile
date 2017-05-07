//
//  Personnel.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 19/3/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import Foundation
import SwiftyJSON

class Personnel: NSObject {
    //MARK: - Properties
    let id: String
    let userName: String
    let firstName: String
    let lastName: String
    let position: String
    let department: String
    let group: String
    let mobilePersonnel: String
    let mobileOffice: String
    let laneLineOffice: String
    let laneLineHome: String
    let emailPrimary: String
    let emailSecondary: String
    let userPicture: String
    let securityLevel: Int?
    let loginAllowed: Bool?
    let passwordHash: String
    let passwordSalt: String
    let isAvailable: Bool?
    let isDeleted: Bool?
    let timeSheetProfileId: Int?
    let pinNumberHash: String
    let pinNumberSalt: String
    let salesSchedulingName: String
    let batchRunInfoList: [BatchRunInfo]?
    
    
    //MARK: - Init
    
    init (id: String, userName: String, firstName: String, lastName: String, position: String, department: String, group: String, mobilePersonnel: String, mobileOffice: String, laneLineOffice: String, laneLineHome: String, emailPrimary: String, emailSecondary: String, userPicture: String, securityLevel: Int, loginAllowed: Bool, passwordHash: String, passwordSalt: String, isAvailable: Bool, isDeleted: Bool, timeSheetProfileId: Int, pinNumberHash: String, pinNumberSalt: String, salesSchedulingName: String, batchRunInfoList: [BatchRunInfo]) {
        self.id = id
        self.userName = userName
        self.firstName = firstName
        self.lastName = lastName
        self.position = position
        self.department = department
        self.group = group
        self.mobileOffice = mobileOffice
        self.mobilePersonnel = mobilePersonnel
        self.laneLineHome = laneLineHome
        self.laneLineOffice = laneLineOffice
        self.emailPrimary = emailPrimary
        self.emailSecondary = emailSecondary
        self.userPicture = userPicture
        self.securityLevel = securityLevel
        self.loginAllowed = loginAllowed
        self.passwordHash = passwordHash
        self.passwordSalt = passwordSalt
        self.isDeleted = isDeleted
        self.isAvailable = isAvailable
        self.timeSheetProfileId = timeSheetProfileId
        self.pinNumberHash = pinNumberHash
        self.pinNumberSalt = pinNumberSalt
        self.salesSchedulingName = salesSchedulingName
        self.batchRunInfoList = batchRunInfoList
    }
}

class PersonnelMap {
    
    static func mapUser(personnelJson: JSON) -> Personnel {
        return Personnel(id: personnelJson["id"].stringValue, userName: personnelJson["userName"].stringValue, firstName: personnelJson["firstName"].stringValue, lastName: personnelJson["lastName"].stringValue, position: personnelJson["position"].stringValue, department: personnelJson["department"].stringValue, group: personnelJson["group"].stringValue, mobilePersonnel: personnelJson["mobilePersonnel"].stringValue, mobileOffice: personnelJson["mobileOffice"].stringValue, laneLineOffice: personnelJson["laneLineOffice"].stringValue, laneLineHome: personnelJson["laneLineHome"].stringValue, emailPrimary: personnelJson["emailPrimary"].stringValue, emailSecondary: personnelJson["emailSecondary"].stringValue, userPicture: personnelJson["userPicture"].stringValue, securityLevel: personnelJson["securityLevel"].intValue, loginAllowed: personnelJson["loginAllowed"].boolValue, passwordHash: personnelJson["passwordHash"].stringValue, passwordSalt: personnelJson["passwordSalt"].stringValue, isAvailable: personnelJson["isAvailable"].boolValue, isDeleted: personnelJson["isDeleted"].boolValue, timeSheetProfileId: personnelJson["timeSheetProfileId"].intValue, pinNumberHash: personnelJson["pinNumberHash"].stringValue, pinNumberSalt: personnelJson["pinNumberSalt"].stringValue, salesSchedulingName: personnelJson["salesSchedulingName"].stringValue, batchRunInfoList: BatchRunInfoMap.mapBatchRunInfo(batchRunInfoJson: personnelJson["batchRunInfoList"]))
    }
    
    static func mapUserList(personnelJsonList: JSON) -> [Personnel] {
        var personnelList : [Personnel] = []
        if personnelJsonList.count != 0 {
            for index in 0...personnelJsonList.count-1 {
                let personnelJson: JSON = personnelJsonList[index]
                personnelList.append(mapUser(personnelJson: personnelJson))
            }
        }
        return personnelList
    }
}
