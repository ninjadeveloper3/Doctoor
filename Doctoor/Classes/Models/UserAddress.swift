//
//  UserAddress.swift
//  Doctoor
//
//  Created by DevBatch on 01/11/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

class UserAddress: Mappable {


    var firstName = ""
    var lastName = ""
    var mobileNumber = ""
    var email = ""
    var address = ""
    var province = ""
    var city = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {

        firstName       <-  map["first_name"]
        lastName        <-  map["last_name"]
        email           <-  map["email"]
        address         <-  map["home_address"]
        province        <-  map["province"]
        city            <-  map["city"]
        mobileNumber    <-  map["phone"]
    }
}
