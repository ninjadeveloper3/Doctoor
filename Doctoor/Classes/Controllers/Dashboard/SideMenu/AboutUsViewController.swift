//
//  AboutUsViewController.swift
//  Doctoor
//
//  Created by DevBatch on 25/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "About ", secondTitle: "Us")
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel

    }
    
    @IBAction func termsButtonTapped(_ sender: Any) {
        let aboutUsViewController =  WebViewController()
        aboutUsViewController.webType = .termsCondition
        aboutUsViewController.addCustomBackButton()
        self.navigationController?.pushViewController(aboutUsViewController, animated: true)
    }
    
    @IBAction func aboutUsButtonTapped(_ sender: Any) {
        let aboutUsViewController =  WebViewController()
        aboutUsViewController.webType = .aboutUs
        aboutUsViewController.addCustomBackButton()
        self.navigationController?.pushViewController(aboutUsViewController, animated: true)
    }
}
