//
//  BatchRun.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 19/3/17.
//  Copyright © 2017 Bilguun. All rights reserved.
//

import Foundation
import SwiftyJSON

class BatchRun: NSObject {
    
    //MARK: - Properties
    let id: Int
    let name: String
    let note: String
    let templateName: String
    let salesName: String
    let scheduledStartDateTime: String
    let startDateTime: String
    let endDateTime: String
    let invoiceNumber: Int?
    let purchaseOrderId: Int?
    let salesSchedulingId: Int?
    let batchTemplateId: Int?
    let personnelId: Int?
    let parentId: Int?
    let status: Int?
    let ganttColor: Int?
    let lastUpdate: String
    let useDefaultRunTime: Bool?
    let instructions: String
    let batchRunType: Int?
    
    //MARK: - Init
    
    init (id: Int, name: String, note: String, templateName: String, salesName: String, scheduledStartDateTime: String, startDateTime: String, endDateTime: String, invoiceNumber: Int, purchaseOrderId: Int?, salesSchedulingId: Int?, batchTemplateId: Int?, personnelId: Int?, parentId: Int?, status: Int?, ganttColor: Int?, lastUpdate: String, useDefaultRunTime: Bool, instructions: String, batchRunType: Int?) {
        self.id = id
        self.name = name
        self.note = note
        self.templateName = templateName
        self.salesName = salesName
        self.scheduledStartDateTime = scheduledStartDateTime
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.invoiceNumber = invoiceNumber
        self.purchaseOrderId = purchaseOrderId
        self.salesSchedulingId = salesSchedulingId
        self.batchTemplateId = batchTemplateId
        self.personnelId = personnelId
        self.parentId = parentId
        self.status = status
        self.ganttColor = ganttColor
        self.lastUpdate = lastUpdate
        self.useDefaultRunTime = useDefaultRunTime
        self.instructions = instructions
        self.batchRunType = batchRunType
    }
}

class BatchRunInfo: NSObject {
    
    let batchRunId: Int
    let batchRunName: String
    let batchRunTemplateId: Int
    let batchRunTemplateName: String
    let status: Int?
    
    init(id: Int, name: String, templateId: Int, templateName: String, status: Int?) {
        self.batchRunId = id
        self.batchRunName = name
        self.batchRunTemplateId = templateId
        self.batchRunTemplateName = templateName
        self.status = status
    }
}

class BatchRunInfoMap {
    
    static func mapBatchRunInfo(batchRunInfoJson: JSON) -> [BatchRunInfo] {
        var batchRunInfoList: [BatchRunInfo] = []
        if batchRunInfoList.count != 0 {
            for index in 0...batchRunInfoJson.count-1 {
                var BatchRun = batchRunInfoJson[index]
                batchRunInfoList.append(BatchRunInfo(id: BatchRun["batchRunId"].intValue, name: BatchRun["batchRunName"].stringValue, templateId: BatchRun["batchRunTemplateId"].intValue, templateName: BatchRun["batchRunTemplateId"].stringValue, status: BatchRun["status"].intValue))
            }
        }
        return batchRunInfoList
    }
}

class BatchRunMap {
    
    static func mapBatchRun(batchRun: JSON) -> BatchRun {
        
        return (BatchRun(id: batchRun["id"].intValue, name: batchRun["name"].stringValue, note: batchRun["note"].stringValue, templateName: batchRun["templateName"].stringValue, salesName: batchRun["salesName"].stringValue, scheduledStartDateTime: batchRun["scheduledStartDateTime"].stringValue, startDateTime: batchRun["startDateTime"].stringValue, endDateTime: batchRun["endDateTime"].stringValue, invoiceNumber: batchRun["invoiceNumber"].intValue, purchaseOrderId: batchRun["purchaseOrderId"].intValue, salesSchedulingId: batchRun["salesSchedulingId"].intValue, batchTemplateId: batchRun["batchTemplateId"].intValue, personnelId: batchRun["personnelId"].intValue, parentId: batchRun["parentRunId"].intValue, status: batchRun["status"].intValue, ganttColor: batchRun["ganttColor"].intValue, lastUpdate: batchRun["lastUpdate"].stringValue, useDefaultRunTime: batchRun["useDefaultRunTime"].boolValue, instructions: batchRun["instructions"].stringValue, batchRunType: batchRun["batchRunType"].intValue))
    }
    
    static func mapBatchRuns(batchRunListJson: JSON) -> [BatchRun] {
        
        var batchRunList: [BatchRun] = []
        if batchRunListJson.count != 0 {
            for index in 0...batchRunListJson.count-1 {
                let batchRun: JSON = batchRunListJson[index]
                batchRunList.append(mapBatchRun(batchRun: batchRun))
            }
        }
        return batchRunList
    }
}
