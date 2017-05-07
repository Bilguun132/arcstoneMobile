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

class Dashboard: NSObject {
    
    let id: String
    let name: String
    let type: String
    let xml: XMLIndexer
    
    init(id: String, name: String, type: String, xml: XMLIndexer ) {
        self.id = id
        self.name = name
        self.type = type
        self.xml = xml
    }
}

class mapDashboard {
    static func mapDashboard(dashboardJSON: JSON) -> Dashboard {
        return Dashboard(id: dashboardJSON["id"].stringValue, name: dashboardJSON["name"].stringValue, type: dashboardJSON["type"].stringValue, xml: SWXMLHash.parse(dashboardJSON["xml"].stringValue))
    }
    
    static func mapDashboardList(dashboardListJSON: JSON) -> [Dashboard] {
        var dashboardList: [Dashboard] = []
        if dashboardListJSON.count != 0 {
            for index in 0...dashboardListJSON.count-1 {
                let dashboardJSON = dashboardListJSON[index]
                dashboardList.append(mapDashboard(dashboardJSON: dashboardJSON))
            }
        }
        return dashboardList
    }
}
