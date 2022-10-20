//
//  Result.swift
//  Doctoor
//
//  Created by DevBatch on 29/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
    
    func toArray() -> [Element] {
        return self.map{$0}
    }
}

extension RealmSwift.List {
    
    func toArray() -> [Element] {
        return self.map{$0}
    }
}
