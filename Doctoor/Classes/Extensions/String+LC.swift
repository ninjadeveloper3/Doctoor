//
//  String+LC.swift
//  Doctoor
//
//  Created byDevBatch on 19/06/2017.
//  Copyright © 2017DevBatch. All rights reserved.
//

import UIKit
import Foundation

extension String
{

    func fromBase64() -> String
    {
        let data = Data(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
        return String(data: data!, encoding: String.Encoding.utf8)!
    }

    func toBase64() -> String
    {
        let data = self.data(using: String.Encoding.utf8)
        return data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }

    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)

        let result =  emailPredicate.evaluate(with: self)

        return result

    }
    
    func isValidPassword() -> Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789")

        if rangeOfCharacter(from: characterset.inverted) != nil && count >= 8 {
            return true

        } else {
            return false
        }
    }
    
    static func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime/1000)
        
        // Returns date formatted as 12 hour time.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    func timeStringFromUnix(unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        
        // Returns date formatted as 12 hour time.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: date)
    }
    
    static func timeDetailStringFromUnixTime(unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime/1000)
        
        // Returns date formatted as 12 hour time.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
//    static func makeTextUnderLineAndCenter(preText: String, underLineText: String, postText: String) -> NSAttributedString {
//
//        let style = NSMutableParagraphStyle()
//        style.alignment = NSTextAlignment.center
//
//        let underlineAttrs = [NSAttributedString.Key.font : UIFont.appThemeFontWithSize(16.0) as AnyObject, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue as AnyObject, NSAttributedString.Key.paragraphStyle: style as AnyObject]
//        let attributedString = NSMutableAttributedString(string:underLineText, attributes:underlineAttrs as [String:AnyObject])
//
//        let lightAttr = [NSFontAttributeName : UIFont.appThemeFontWithSize(16.0) as AnyObject, NSParagraphStyleAttributeName: style as AnyObject]
//        let finalAttributedText = NSMutableAttributedString(string:preText, attributes:lightAttr as [String:AnyObject])
//
//        let postText = NSMutableAttributedString(string:postText, attributes:lightAttr as [String:AnyObject])
//
//        finalAttributedText.append(attributedString)
//        finalAttributedText.append(postText)
//
//        return finalAttributedText
//    }

    static func makeTextBold(_ preBoldText:String, boldText:String, postBoldText:String, fontSzie:CGFloat) -> NSAttributedString {

        let boldAttrs = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont.appThemeBoldFontWithSize(fontSzie)]
        let attributedString = NSAttributedString(string:boldText, attributes:boldAttrs)

        let lightAttr = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.appThemeFontWithSize(fontSzie)]
        let finalAttributedText = NSMutableAttributedString(string:preBoldText, attributes:lightAttr)

        let postText = NSAttributedString(string:postBoldText, attributes:lightAttr)

        finalAttributedText.append(attributedString)
        finalAttributedText.append(postText)

        return finalAttributedText
    }
//
//    static func makeTextSemiBold(_ preBoldText:String, boldText:String, postBoldText:String, fontSzie:CGFloat) -> NSAttributedString {
//
//        let boldAttrs = [NSFontAttributeName : UIFont.appThemeSemiBoldFontWithSize(fontSzie) as AnyObject]
//        let attributedString = NSMutableAttributedString(string:boldText, attributes:boldAttrs as [String:AnyObject])
//
//        let lightAttr = [NSFontAttributeName : UIFont.appThemeFontWithSize(fontSzie) as AnyObject]
//        let finalAttributedText = NSMutableAttributedString(string:preBoldText, attributes:lightAttr as [String:AnyObject])
//
//        let postText = NSMutableAttributedString(string:postBoldText, attributes:lightAttr as [String:AnyObject])
//
//        finalAttributedText.append(attributedString)
//        finalAttributedText.append(postText)
//
//        return finalAttributedText
//    }
//
//    func safelyLimitedTo(length n: Int)->String {
//        let c = self.characters
//        if (c.count <= n) { return self }
//        return String( Array(c).prefix(upTo: n) )
//    }

    func grouping(every groupSize: String.IndexDistance, with separator: Character) -> String {
        let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
        return String(cleanedUpCopy.enumerated().map() {
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
            }.joined().dropFirst())
    }
}
