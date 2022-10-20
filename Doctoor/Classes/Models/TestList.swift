//
//  TestList.swift
//  Doctoor
//
//  Created by DevBatch on 21/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class TestList: Mappable {
 
    var id = 0
    var testName = ""
    var logo = ""
    var description = ""
    var labId = 0
    var testCategoryId = 0
    var indemand = 0
    var price = 0.0
    var isCart = false
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        testName        <-  map["test_name"]
        logo            <-  map["logo"]
        description     <-  map["description"]
        labId           <-  map["lab_id"]
        testCategoryId  <-  map["testcategory_id"]
        price           <-  map["price"]
    }
}
