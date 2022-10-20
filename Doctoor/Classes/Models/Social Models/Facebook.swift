//
//  File.swift
//  Doctoor
//
//  Created by DevBatch on 01/11/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class Facebook: Mappable {
    
    var id = 0
    var email = ""
    var first_name = ""
    var last_name = ""
    var name = ""
    var token = ""
    var picture = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        name            <-  map["name"]
        first_name      <-  map["first_name"]
        last_name       <-  map["last_name"]
        email           <-  map["email"]
        token           <-  map["token"]
        picture         <-  map["picture"]
    }
}
