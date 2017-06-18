//
//  BatchRunStepParameter.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 1/4/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import Foundation
import SwiftyJSON

class batchRunStepParameter: NSObject {
    
    //MARK: - Properties
    let id: Int
    let name: String
    let expectedValue: String
    let templateNotes: String
    var actualValue: String
    let notes: String
    let batchRunStepId: Int?
    let batchTemplateStepParameterId: Int?
    let batchTemplateId: Int?
    let diagramId: Int?
    let contentManagerId: Int?
    let xmlParameters: String
    
    //MARK - Init
    init(id: Int, name: String, expectedValue: String, templateNotes: String, actualValue: String, notes: String, batchRunStepId: Int?, batchTemplateStepParameterId: Int?, batchTemplateId: Int?, diagramId: Int?, contentManagerId: Int?, xmlParameters: String) {
        self.id = id
        self.name = name
        self.expectedValue = expectedValue
        self.templateNotes = templateNotes
        self.actualValue = actualValue
        self.notes = notes
        self.batchRunStepId = batchRunStepId
        self.batchTemplateStepParameterId = batchTemplateStepParameterId
        self.batchTemplateId = batchTemplateId
        self.diagramId = diagramId
        self.contentManagerId = contentManagerId
        self.xmlParameters = xmlParameters
    }
}

class batchRunStepParameterMap {
    
    static func mapBatchRunStepParameter(batchRunStepParameterJSON: JSON) -> batchRunStepParameter {
        return batchRunStepParameter(id: batchRunStepParameterJSON["id"].intValue, name: batchRunStepParameterJSON["name"].stringValue, expectedValue: batchRunStepParameterJSON["expectedValue"].stringValue, templateNotes: batchRunStepParameterJSON["templateNotes"].stringValue, actualValue: batchRunStepParameterJSON["actualValue"].stringValue, notes: batchRunStepParameterJSON["notes"].stringValue, batchRunStepId: batchRunStepParameterJSON["batchRunStepId"].intValue, batchTemplateStepParameterId: batchRunStepParameterJSON["batchTemplateStepParameterId"].intValue, batchTemplateId: batchRunStepParameterJSON["batchTemplateId"].intValue, diagramId: batchRunStepParameterJSON["diagramId"].intValue, contentManagerId: batchRunStepParameterJSON["contentManagerId"].intValue, xmlParameters: batchRunStepParameterJSON["xmlParameters"].stringValue)
    }
    
    static func mapBatchRunStepParameterList(batchRunStepParameterListJSON: JSON) -> [batchRunStepParameter] {
        
        var batchRunStepParameterList: [batchRunStepParameter] = []
        if batchRunStepParameterListJSON.count != 0 {
            for index in 0...batchRunStepParameterListJSON.count-1 {
                let batchRunStepParameter: JSON = batchRunStepParameterListJSON[index]
                batchRunStepParameterList.append(mapBatchRunStepParameter(batchRunStepParameterJSON: batchRunStepParameter))
            }
        }
        return batchRunStepParameterList
    }
}
