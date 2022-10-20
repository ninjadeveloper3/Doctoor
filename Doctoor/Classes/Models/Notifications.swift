//
//  Notifications.swift
//  Doctoor
//
//  Created by DevBatch on 16/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class Notifications: Mappable {

    var id = 0
    var userId = 0
    var noteTitle = ""
    var noteBody = ""
    var noteType = 0
    var paid = 0
    var createdAt = ""
    var totalAmount = 0.0
    var orderId = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id          <-  map["id"]
        userId      <-  map["user_id"]
        noteTitle   <-  map["note_title"]
        noteBody    <-  map["note_body"]
        noteType    <-  map["note_type"]
        paid        <-  map["is_paid"]
        createdAt   <-  map["created_at"]
        totalAmount <-  map["total_amount"]
        orderId     <-  map["note_heading"]
    }
}
