//
//  LabTest.swift
//  Doctoor
//
//  Created by DevBatch on 17/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//


import Foundation
import ObjectMapper

class LabTest: Mappable {
    
    var id = 0
    var labName = ""
    var logo = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id          <-  map["id"]
        labName     <-  map["lab_name"]
        logo        <-  map["logo"]
    }
}

