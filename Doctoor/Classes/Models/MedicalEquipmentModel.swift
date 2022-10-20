//
//  MedicalEquipmentModel.swift
//  Doctoor
//
//  Created by DevBatch on 22/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class MedicalEquip: Mappable {
    
    var id = 0
    var equipName = ""
    var brand = ""
    var image = ""
    var price = 0.0
    var inDemand = 0
    var quantity = 0
    var status = 0
    var description = ""
    var isCart = false
    var isRental = false
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id          <-  map["id"]
        equipName   <-  map["equipment_name"]
        brand       <-  map["brand"]
        image       <-  map["image"]
        price       <-  map["price"]
        inDemand    <-  map["in_demand"]
        quantity    <-  map["quantity"]
        status      <-  map["status"]
        description <-  map["description"]
        isRental    <-  map["is_rental"]

    }
}

class MedicalRentalEquip: Mappable {
    
    var id = 0
    var orderNumber = ""
    var status = 0
    var paymentMethodId = 0
    var comment = ""
    var price = 0.0
    var equipmentName = ""
    var createdAt = ""
    var cityId = 0

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["equipment_id"]
        orderNumber     <-  map["order_number"]
        status          <-  map["status"]
        paymentMethodId <-  map["payment_method_id"]
        comment         <-  map["comment"]
        price           <-  map["price"]
        equipmentName   <- map["equipment_name"]
        createdAt       <- map ["created_at"]
        cityId          <- map ["city_id"]
        
    }
}

