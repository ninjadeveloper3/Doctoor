//
//  Prescription.swift
//  Doctoor
//
//  Created by Moiz Amjad on 09/04/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class Prescription: Mappable {
    
    
    var id = 0
    var testId = 0
    var name = ""
    var path = ""
    var createdAt = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id          <-  map["id"]
        name        <-  map["name"]
        path   <-  map["prescription_path"]
        createdAt   <-  map["created_at"]
    }
}
