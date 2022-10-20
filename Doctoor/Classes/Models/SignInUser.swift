//
//  SignInUser.swift
//  Doctoor
//
//  Created by DevBatch on 15/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class SignInUser: Mappable {
    
    var id = 0
    var fullName = ""
    var email = ""
    var token = ""
    var shippingId = 0
    var billingId = 0
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id          <-  map["id"]
        fullName    <-  map["fullName"]
        email       <-  map["email"]
        token       <-  map["token"]
    }
}

