//
//  NSMutableAttributedString+LC.swift
//  Doctoor
//
//  Created byDevBatch on 18/01/2018.
//  Copyright © 2018DevBatch. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {

    @discardableResult func normal(_ text:String)->NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
}
