//
//  MedicineCategory.swift
//  Doctoor
//
//  Created by DevBatch on 21/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class MedicineCategory: Mappable {
    
    var id = 0
    var image = ""
    var categoryName = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        image           <-  map["image"]
        categoryName    <-  map["category_name"]
    }
}
