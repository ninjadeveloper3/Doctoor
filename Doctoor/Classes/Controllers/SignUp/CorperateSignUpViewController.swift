//
//  CorperateSignUpViewController.swift
//  Doctoor
//
//  Created by DevBatch on 26/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class CorperateSignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func proceedButtonTapped(_ sender: Any) {
        let signUpViewController  = SignUppViewController()
        signUpViewController.isLogin = false
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }
}
