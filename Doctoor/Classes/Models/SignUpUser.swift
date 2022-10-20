//
//  File.swift
//  Doctoor
//
//  Created by DevBatch on 15/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper
class SignUpUser: Mappable {
    
    var id = 0
    var email = ""
    var token = ""
    var fullName = ""
    var phone = ""
    var gender = ""
    var activationCode = 0
    var avatar = ""
    var billingId = 0
    var isActive = 0
    var loginType = ""
    var playerId = 0
    var roleId = 0
    var shippingId = 0
    var socialToken = 0
    var socialId = 0
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <-  map["id"]
        fullName        <-  map["full_name"]
        email           <-  map["email"]
        token           <-  map["token"]
        phone           <-  map["phone"]
        gender          <-  map["gender"]
        activationCode  <-  map["activation_code"]
        avatar          <-  map["avatar"]
        billingId       <-  map["billing_id"]
        isActive        <-  map["is_active"]
        loginType       <-  map["login_type"]
        playerId        <-  map["player_id"]
        roleId          <-  map["role_id"]
        shippingId      <-  map["shipping_id"]
        socialToken     <-  map["social_access_token"]
        socialId        <-  map["social_id"]
    }
}
