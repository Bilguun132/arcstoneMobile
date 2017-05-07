//
//  BatchRunStep.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 19/3/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import Foundation
import SwiftyJSON

class BatchRunStep: NSObject {
    
    //MARK: - Properties
    let id: Int
    let name: String
    let expectedStartDateTime: String
    let splitStepExpectedEndDateTime: String
    let startDateTime: String
    let endDateTime: String
    let note: String
    let batchRunId: Int?
    let batchTemplateStepId: Int?
    let personnelId: Int?
    let index: Int?
    let status: Int?
    let ganttColor: Int?
    let useDefaultRunTime: Bool?
    let customRunTime: Float?
    let isDeleted: Bool?
    let instructions: String
    let inUse: Bool?
    let timeSheetProfileId: Int?
    let customCurrentValuesDataTimingLinkId: Int?
    let customExpectedMinTime: Float?
    let customExpectedMaxTime: Float?
    
    //MARK: - Init
    
    init (id: Int, name: String, expectedStartDateTime: String, splitExpectedEndDateTime: String, startDateTime: String, endDateTime: String, note: String, batchRunId: Int?, batchTemplateStepId: Int?, personnelId: Int?, index: Int?, status: Int?, ganttColor: Int?, useDefaultRunTime: Bool?, customRunTime: Float?, isDeleted: Bool?, instructions: String, inUse: Bool?, timeSheetProfileId: Int?, customCurrentValuesDataTimingLinkId: Int?, customExpectedMinTime: Float?, customExpectedMaxTime: Float?) {
        self.id = id
        self.name = name
        self.expectedStartDateTime = expectedStartDateTime
        self.splitStepExpectedEndDateTime = splitExpectedEndDateTime
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.note = note
        self.batchRunId = batchRunId
        self.batchTemplateStepId = batchTemplateStepId
        self.personnelId = personnelId
        self.index = index
        self.status = status
        self.ganttColor = ganttColor
        self.useDefaultRunTime = useDefaultRunTime
        self.customRunTime = customRunTime
        self.isDeleted = isDeleted
        self.instructions = instructions
        self.inUse = inUse
        self.timeSheetProfileId = timeSheetProfileId
        self.customCurrentValuesDataTimingLinkId = customCurrentValuesDataTimingLinkId
        self.customExpectedMinTime = customExpectedMinTime
        self.customExpectedMaxTime = customExpectedMaxTime
    }
}

class BatchRunStepMap {
    
    static func BatchRunStepMap(BatchStepListJson:JSON) -> [BatchRunStep] {
        var BatchRunStepList: [BatchRunStep] = []
        if BatchStepListJson.count != 0 {
            for index in 0...BatchStepListJson.count-1 {
                var BatchStep = BatchStepListJson[index]
                BatchRunStepList.append(BatchRunStep(id: BatchStep["id"].intValue, name: BatchStep["name"].stringValue, expectedStartDateTime: BatchStep["expectedStartDateTime"].stringValue, splitExpectedEndDateTime: BatchStep["splitStepExpectedEndDateTime"].stringValue, startDateTime: BatchStep["startDateTime"].stringValue, endDateTime: BatchStep["endDateTime"].stringValue, note: BatchStep["notes"].stringValue, batchRunId: BatchStep["batchRunId"].intValue, batchTemplateStepId: BatchStep["batchTemplateStepId"].intValue, personnelId: BatchStep["personnelId"].intValue, index: BatchStep["index"].intValue, status: BatchStep["status"].intValue, ganttColor: BatchStep["ganttColor"].intValue, useDefaultRunTime: BatchStep["useDefaultRunTime"].boolValue, customRunTime: BatchStep["customRunTime"].floatValue, isDeleted: BatchStep["isDeleted"].boolValue, instructions: BatchStep["instructions"].stringValue, inUse: BatchStep["inUse"].boolValue, timeSheetProfileId: BatchStep["timesheetProfileId"].intValue, customCurrentValuesDataTimingLinkId: BatchStep["customCurrentValuesDataTimingLinkId"].intValue, customExpectedMinTime: BatchStep["customExpectedMinTmie"].floatValue, customExpectedMaxTime: BatchStep["customExpectedMaxValue"].floatValue))
            }
        }
        return BatchRunStepList
    }
    
}
