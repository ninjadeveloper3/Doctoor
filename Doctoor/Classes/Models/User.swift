//
//  User.swift
//  Doctoor
//
//  Created byDevBatch on 10/07/2017.
//  Copyright © 2017DevBatch. All rights reserved.
//

import Foundation
import ObjectMapper

final class User {

    // Can't init is singleton
    private init() { }

    // MARK: Shared Instance

    static let shared = User()

    // MARK: Local Variable

    
    var id = 0
    var email = ""
    var token = ""
    var fullName = ""
    var phone = ""
    var gender = ""
    var activationCode = 0
    var avatar = ""
    var billingId = ""
    var isActive = ""
    var loginType = ""
    var playerId = 0
    var roleId = 0
    var shippingId = 0
    var socialToken = 0
    var socialId = 0
}


