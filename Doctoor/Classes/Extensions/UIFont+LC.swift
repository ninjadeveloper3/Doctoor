//
//  UIFont+LC.swift
//  Doctoor
//
//  Created byDevBatch on 19/06/2017.
//  Copyright © 2017DevBatch. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {

    class func appThemeFontWithSize(_ fontSize: CGFloat) -> UIFont {

        if let font = UIFont(name: "Mark Pro", size: fontSize) {
            return font
        }

        return UIFont.systemFont(ofSize: fontSize)
    }

    class func appThemeBoldFontWithSize(_ fontSize: CGFloat) -> UIFont {

        if let font = UIFont(name: "MarkPro-Bold", size: fontSize) {
            return font
        }

        return UIFont.systemFont(ofSize: fontSize)
    }

    class func appThemeSemiBoldFontWithSize(_ fontSize: CGFloat) -> UIFont {

        if let font = UIFont(name: "MarkPro-Book", size: fontSize) {
            return font
        }

        return UIFont.systemFont(ofSize: fontSize)
    }

    class func sevenSegmentFontWithSize(_ fontSize: CGFloat) -> UIFont {

        if let font = UIFont(name: "Mark Pro Semi Bold", size: fontSize) {
            return font
        }

        return UIFont.systemFont(ofSize: fontSize)
    }

}
