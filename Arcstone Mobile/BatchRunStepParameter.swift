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
    let actualValue: String
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
