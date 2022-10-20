//
//  LabCategory.swift
//  Doctoor
//
//  Created by DevBatch on 17/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class LabCategory: Mappable {

    var id = 0
    var labId = 0
    var testCategoryName = ""
    var categoryLogo = ""
    var testCatId = 0
    var catName = ""
    var catImage = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id                  <-  map["id"]
        labId               <-  map["lab_id"]
        testCategoryName    <-  map["test_category_name"]
        categoryLogo        <-  map["category_logo"]
        testCatId           <-  map["testcategory_id"]
        catName             <-  map["test_category.category_name"]
        catImage            <-  map["test_category.logo"]
    }
}
