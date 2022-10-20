//
//  Array.swift
//  Doctoor
//
//  Created by DevBatch on 25/11/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import Foundation

extension Array {
    init(repeating: [Element], count: Int) {
        self.init([[Element]](repeating: repeating, count: count).flatMap{$0})
    }
    
    func repeated(count: Int) -> [Element] {
        return [Element](repeating: self, count: count)
    }
}
