//
//  Order.swift
//  Doctoor
//
//  Created by DevBatch on 16/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class ServiceOrderHistory: Mappable {
    
    var id = 0
    var orderNumber = ""
    var serviceId = 0
    var orderFromUser = 0
    var comments = ""
    var paymentStatus = 0
    var totalAmount = 0.0
    var orderStatus = 0
    var orderFor = ""
    var createdAt = ""
    var cityId = 0
    var paymentMethod = 0
    var image = ""
    
    var service =  Mapper<ServiceModel>().map(JSON: [:])!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        orderNumber     <-  map["order_number"]
        serviceId       <-  map["service_id"]
        orderFromUser   <-  map["order_from_user"]
        comments        <-  map["comments"]
        paymentStatus   <-  map["payment_status"]
        totalAmount     <-  map["total_amount"]
        orderStatus     <-  map["status"]
        orderFor        <-  map["order_for"]
        createdAt       <-  map["created_at"]
        cityId          <-  map["city_id"]
        paymentMethod   <-  map["payment_method_id"]
        service         <-  map["service"]
        image           <-  map["image"]
    }
}

class ServiceOrderDetails: Mappable {
    
    var id = 0
    var serviceName = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        serviceName     <-  map["service_name"]
    }
}


