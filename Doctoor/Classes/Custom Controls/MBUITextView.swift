//
//  MBUITextView.swift
//  Doctoor Labour
//
//  Created byDevBatch on 22/08/2017.
//  Copyright © 2017DevBatch. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable public class MBUITextView: UITextView, UITextViewDelegate {

    @IBInspectable public var placeHolder: String = ""

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        setupPlaceHolder()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        setupPlaceHolder()
        self.delegate = self
    }

    @IBInspectable
    public var placeholderTextt: String = "" {
        didSet {
            self.placeHolder = placeholderTextt
            self.setupPlaceHolder()
            self.setNeedsLayout()
        }
    }

    func setupPlaceHolder() {

        if placeHolder != "" {
            self.attributedText = NSAttributedString(string: self.placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.emailTextFiledPlaceHolderTextColor(), NSAttributedString.Key.font: UIFont.appThemeFontWithSize(15.0)])
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {

    }

    public func textViewDidChange(_ textView: UITextView) {

        if textView.text == "" {
            setupPlaceHolder()
        }
    }

    public override func shouldChangeText(in range: UITextRange, replacementText text: String) -> Bool {
        
        return true
    }
}
