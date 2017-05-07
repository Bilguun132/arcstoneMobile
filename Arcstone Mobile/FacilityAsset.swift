//
//  FacilityAsset.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 19/3/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import Foundation
import SwiftyJSON

class FacilityAsset: NSObject {
    
    //MARK - Properties
    let id: Int
    let name: String
    let facilityAssetTypeId: Int?
    let isAvailable: Bool?
    let isDeleted: Bool?
    let facilityLinkId: Int?
    let timeSheetProfileId: Int?
    let dateTimePurchased: String
    let dateTimeInstalled: String
    let dateTimeFirstRun: String
    let dateTimeLatestMaintenance: String
    let dateTimeLatestAlarm: String
    let capacity: Float?
    let uomId: Int?
    let numberOfRunSinceMaintenance: Int?
    let status: Int?
    let facilityAssetDescription: String
    
    //MARK: - Init
    init(id: Int, name: String, facilityAssetTypeId: Int?, isAvailable: Bool?, isDeleted: Bool?, facilityLinkId: Int?, timeSheetProfileId: Int?, dateTimePurchased: String, dateTimeInstalled: String, dateTimeFirstRun: String, dateTimeLatestMaintenance: String, dateTimeLatestAlarm: String, capacity: Float?, uomId: Int?, numberOfRunSinceMaintenance: Int?, status: Int?, facilityAssetDescription: String) {
        self.id = id
        self.name = name
        self.facilityAssetTypeId = facilityAssetTypeId
        self.isAvailable = isAvailable
        self.isDeleted = isDeleted
        self.facilityLinkId = facilityLinkId
        self.timeSheetProfileId = timeSheetProfileId
        self.dateTimePurchased = dateTimePurchased
        self.dateTimeInstalled = dateTimeInstalled
        self.dateTimeFirstRun = dateTimeFirstRun
        self.dateTimeLatestMaintenance = dateTimeLatestMaintenance
        self.dateTimeLatestAlarm = dateTimeLatestAlarm
        self.capacity = capacity
        self.uomId = uomId
        self.numberOfRunSinceMaintenance = numberOfRunSinceMaintenance
        self.status = status
        self.facilityAssetDescription = facilityAssetDescription
    }
}

class FacilityAssetMap {
    
    static func mapFacilityAsset(facilityAsset:JSON) -> FacilityAsset {
        return FacilityAsset(id: facilityAsset["id"].intValue, name: facilityAsset["name"].stringValue, facilityAssetTypeId: facilityAsset["facilityAssetTypeId"].intValue, isAvailable: facilityAsset["isAvailable"].boolValue, isDeleted: facilityAsset["isDeleted"].boolValue, facilityLinkId: facilityAsset["facilityLinkId"].intValue, timeSheetProfileId: facilityAsset["timesheetProfileId"].intValue, dateTimePurchased: facilityAsset["dateTimePurchased"].stringValue, dateTimeInstalled: facilityAsset["dateTimeInstalled"].stringValue, dateTimeFirstRun: facilityAsset["dateTimeFirstRun"].stringValue, dateTimeLatestMaintenance: facilityAsset["dateTimeLatestMaintenance"].stringValue, dateTimeLatestAlarm: facilityAsset["dateTimeLatestAlarm"].stringValue, capacity: facilityAsset["capacity"].floatValue, uomId: facilityAsset["uomId"].intValue, numberOfRunSinceMaintenance: facilityAsset["numberOfRunSinceLastMaintenance"].intValue, status: facilityAsset["status"].intValue, facilityAssetDescription: facilityAsset["facilityAssetDescription"].stringValue)
    }
    
    static func mapFacilityAssetList(facilityAssetList:JSON) -> [FacilityAsset] {
        var facilityList: [FacilityAsset] = []
        for index in 0...facilityAssetList.count {
            let facilityAsset = facilityAssetList[index]
            facilityList.append(mapFacilityAsset(facilityAsset: facilityAsset))
        }
        return facilityList
    }
}
