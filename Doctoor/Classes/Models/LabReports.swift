//
//  LabReports.swift
//  Doctoor
//
//  Created by DevBatch on 21/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class LabReports: Mappable {
    
    
    var id = 0
    var userId = 0
    var testId = 0
    var file = ""
    var deletedAt = ""
    var createdAt = ""
    var updatedAt = ""
    var test = Mapper<TestList>().map(JSON: [:])!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id          <-  map["id"]
        userId      <-  map["user_id"]
        testId      <-  map["test_id"]
        file        <-  map["file"]
        deletedAt   <-  map["deleted_at"]
        createdAt   <-  map["created_at"]
        updatedAt   <-  map["updated_at"]
        test        <-  map["test"]
    }
}
