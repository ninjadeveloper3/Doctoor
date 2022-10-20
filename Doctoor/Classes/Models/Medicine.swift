//
//  Medicine.swift
//  Doctoor
//
//  Created by DevBatch on 21/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class SearchMedicine: Mappable {
    
    var medicines = [MedicineItem]()
    var miscellaneous = [MedicineItem]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        medicines       <-  map["medicines"]
        miscellaneous   <-  map["miscellaneous"]
    }
}

class MedicineItem: Mappable {
    
    var id = 0
    var medicineName = ""
    var categoryId = 0
    var availableQuantity = 0
    var price = 0.0
    var medicineImage = ""
    var brand = ""
    var unit = ""
    var brandLogo = ""
    var primaryUse = ""
    var composition = ""
    var howToTake = ""
    var isPrescriptionRequired = 0
    var isCart = false
    var warnings = [Warnings]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id                  <-  map["id"]
        medicineName        <-  map["medicine_name"]
        categoryId          <-  map["category_id"]
        availableQuantity   <-  map["available_quantity"]
        price               <-  map["price"]
        medicineImage       <-  map["medicine_image"]
        brand               <-  map["brand"]
        unit                <-  map["unit"]
        brandLogo           <-  map["brand_logo"]
        primaryUse          <-  map["primary_use"]
        composition         <-  map["composition"]
        howToTake           <-  map["how_to_take"]
        isPrescriptionRequired <- map["is_prescription_req"]
        warnings            <-  map["warnings"]
    }
}

class Warnings: Mappable {
    
    var detail = ""
    var title = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        detail      <-  map["detail"]
        title       <-  map["title"]
    }
}
