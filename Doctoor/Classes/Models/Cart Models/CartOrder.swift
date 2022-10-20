//
//  CartOrder.swift
//  Doctoor
//
//  Created by DevBatch on 23/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class CartOrder: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var productId = 0
    @objc dynamic var quantity = 1
    @objc dynamic var productType = ProductType.Medicine.rawValue
    @objc dynamic var title = ""
    @objc dynamic var price = 0.0
    @objc dynamic var productDescription = ""
    @objc dynamic var isPrescription = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(CartOrder.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
