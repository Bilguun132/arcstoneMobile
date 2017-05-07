//
//  DashboardElement.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 9/4/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import Foundation
import SwiftyJSON
import SWXMLHash

class DashboardElement: NSObject {
    
    let id: String
    let name: String
    let type: String
    let status: String
    let xml: XMLIndexer
    
    init(id: String, name: String, type: String, status: String, xml: XMLIndexer ) {
        self.id = id
        self.name = name
        self.type = type
        self.status = status
        self.xml = xml
    }
}

class mapDashboardElement {
    static func mapDashboardElement(dashboardElementJSON: JSON) -> DashboardElement {
        return DashboardElement(id: dashboardElementJSON["id"].stringValue, name: dashboardElementJSON["name"].stringValue, type: dashboardElementJSON["type"].stringValue, status: dashboardElementJSON["type"].stringValue, xml: SWXMLHash.parse(dashboardElementJSON["xml"].stringValue))
    }
    
    static func mapDashboardElementList(dashboardElementListJSON: JSON) -> [DashboardElement] {
        var dashboardElementList: [DashboardElement] = []
        if dashboardElementListJSON.count != 0 {
            for index in 0...dashboardElementListJSON.count-1 {
                let dashboardElementJSON = dashboardElementListJSON[index]
                dashboardElementList.append(mapDashboardElement(dashboardElementJSON: dashboardElementJSON))
            }
        }
        return dashboardElementList
    }
}
