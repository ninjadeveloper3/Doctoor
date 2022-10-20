//
//  BaseViewController.swift
//  Doctoor
//
//  Created by DevBatch on 12/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewController()
    }
    
    //MARK: - SetUp View Controller Methods
    
    func setUpViewController() {
        
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func corporateSignIn(_ sender: Any) {
        self.navigationController?.pushViewController(CorperateSignUpViewController(), animated: true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.navigationController?.pushViewController(SignInViewController(), animated: true)
    }
    
    @IBAction func signButtonTapped(_ sender: Any) {
        let signUpViewController  = SignUppViewController()
        signUpViewController.isLogin = false
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    @IBAction func termsButtonTapped(_ sender: Any) {
        let navigationController = UINavigationController()
        navigationController.setupAppThemeNavigationBar()
        let confirmViewController = WebViewController()
        confirmViewController.isNavigation = true
        navigationController.viewControllers = [confirmViewController]
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func privacyPolicyButtonTapped(_ sender: Any) {
        let navigationController = UINavigationController()
        navigationController.setupAppThemeNavigationBar()
        let confirmViewController = WebViewController()
        confirmViewController.isNavigation = true
        confirmViewController.webType = .aboutUs
        navigationController.viewControllers = [confirmViewController]
        self.present(navigationController, animated: true, completion: nil)
    }
         
}
