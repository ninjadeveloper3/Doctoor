//
//  InDemandServices.swift
//  Doctoor
//
//  Created by DevBatch on 21/01/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class InDemandServices: Mappable {
    
    var id = 0
    var serviceId = 0
    var cityId = 0
    var serviceName = ""
    var city =  Mapper<CityModel>().map(JSON: [:])!
    var serviceType =  Mapper<ServiceModel>().map(JSON: [:])!
    var image = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        serviceId       <-  map["service_id"]
        cityId          <-  map["city_id"]
        serviceName     <-  map["service_name"]
        city            <- map["city"]
        serviceType     <- map["service_types"]
        image           <-  map["image"]
        
        
        
    }
}

class City: Mappable {
    
    var id = 0
    var province = ""
    var cityName = ""
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        province     <-  map["province"]
        cityName     <-  map["city_name"]
    }
    
}
