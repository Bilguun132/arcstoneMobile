//
//  Facility.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 19/3/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import Foundation
import SwiftyJSON

class Facility: NSObject {
    
    //MARK: - Properties
    let id: Int
    let name: String
    let notes: String
    let address1: String
    let address2: String
    let facilityDescription: String
    let city: String
    let country: String
    let phoneNumber: String
    let mapLatitude: String
    let mapLongitude: String
    let isDeleted: Bool?
    
    //MARK: - Init
    
    init(id: Int, name: String, notes: String, address1: String, address2: String, description: String, city: String, country: String, phoneNumber: String, mapLatitude: String, mapLongitude: String, isDeleted: Bool?) {
        self.id = id
        self.name = name
        self.notes = notes
        self.address1 = address1
        self.address2 = address2
        self.facilityDescription = description
        self.city = city
        self.country = country
        self.phoneNumber = phoneNumber
        self.mapLatitude = mapLatitude
        self.mapLongitude = mapLongitude
        self.isDeleted = isDeleted
    }
}

