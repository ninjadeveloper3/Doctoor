//
//  CitiesModel.swift
//  Doctoor
//
//  Created by DevBatch on 21/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper


class CityModel: Mappable {
    
    
    var id = 0
    var cityName = ""
    var createdAt = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        cityName        <-  map["city_name"]
        createdAt       <-  map["created_at"]
        
    }
}

class ServiceModel: Mappable {
    
    var serviceId = 0
    var serviceName = ""
    var equpmentName = ""
    var id = 0
    var image = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        serviceId       <-  map["id"]
        serviceName     <-  map["service_name"]
        id       <-  map["rental_equipment_id"]
        equpmentName     <-  map["equipment_name"]
        image   <-  map["image"]
    }
}
