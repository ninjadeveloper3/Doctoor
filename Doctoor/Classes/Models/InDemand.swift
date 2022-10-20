//
//  InDemand.swift
//  Doctoor
//
//  Created by DevBatch on 16/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class InDemand: Mappable {
    
    var medicines = [MedicineItem]()
    var equipments = [MedicalEquip]()
    var tests = [TestList]()
 

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        medicines   <-  map["medicines"]
        equipments  <-  map["equipments"]
        tests       <-  map["tests"]
    }
}
