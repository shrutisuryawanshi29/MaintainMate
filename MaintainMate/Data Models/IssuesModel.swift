//
//  IssuesModel.swift
//  MaintainMate
//
//  Created by Shruti Suryawanshi on 2/23/24.
//

import Foundation

public class IssuesModel {
    var documentId: String?
    var buildingFloors: String?
    var buildingName: String?
    var description: String?
    var imageUrl: String?
    var issueId: String?
    var issueType: String?
    var room: String?
    var timestamp: String?
    var uid: String?
    var status: String?
    
    init(documentId: String? = nil, buildingFloors: String? = nil, buildingName: String? = nil, description: String? = nil, imageUrl: String? = nil, issueId: String? = nil, issueType: String? = nil, room: String? = nil, timestamp: String? = nil, uid: String? = nil, status: String? = nil) {
        self.documentId = documentId
        self.buildingFloors = buildingFloors
        self.buildingName = buildingName
        self.description = description
        self.imageUrl = imageUrl
        self.issueId = issueId
        self.issueType = issueType
        self.room = room
        self.timestamp = timestamp
        self.uid = uid
        self.status = status
    }
}
