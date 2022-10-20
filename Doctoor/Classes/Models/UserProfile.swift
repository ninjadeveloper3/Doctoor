//
//  UserProfile.swift
//  Doctoor
//
//  Created by DevBatch on 16/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class UserProfile: Mappable {
    
    var id = 0
    var fullName = ""
    var email = ""
    var phone = ""
    var gender = ""
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id          <-  map["id"]
        fullName    <-  map["full_name"]
        email       <-  map["email"]
        phone       <-  map["phone"]
        gender      <-  map["gender"]
    }
}
