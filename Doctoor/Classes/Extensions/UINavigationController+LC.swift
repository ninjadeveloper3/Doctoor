//
//  UINavigationController+LC.swift
//  Doctoor
//
//  Created byDevBatch on 6/19/17.
//  Copyright © 2017DevBatch. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {

    func transparentNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.modalPresentationStyle = .fullScreen
        self.view.backgroundColor = .clear
    }

    func setAttributedTitle() {
        let attributes = [NSAttributedString.Key.font: UIFont.appThemeFontWithSize(19.0), NSAttributedString.Key.foregroundColor: UIColor.white] //change size as per your need here.
        self.navigationBar.titleTextAttributes = attributes
    }

    func setupAppThemeNavigationBar() {
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(#imageLiteral(resourceName: "header"), for: .default)
        navigationBar.tintColor = .white
        self.modalPresentationStyle = .fullScreen
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.appThemeBoldFontWithSize(20.0)]
    }
}
