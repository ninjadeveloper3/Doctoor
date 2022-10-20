//
//  SignInViewController.swift
//  Doctoor
//
//  Created by DevBatch on 18/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import ObjectMapper
import FacebookLogin
import FacebookCore
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController {
    
    //MARK: - Variables
    
    var dataSource = Mapper<SignUpUser>().map(JSON: [:])!
    var facebookDataSource = Mapper<Facebook>().map(JSON: [:])!
    
    //MARK: - Outlets
    
    @IBOutlet weak var phoneTextField: MBUITextField! {
        didSet {
            phoneTextField.setIcon(#imageLiteral(resourceName: "phone-no"), width: 20, height: 20)
            phoneTextField.isMobileNumberTextField = true
            
        }
    }
    
    @IBOutlet weak var passwordTextField: MBUITextField!
        {
        didSet {
            passwordTextField.setIcon(#imageLiteral(resourceName: "password"), width: 20, height: 20)
            
        }
    }
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        if let accessToken = AccessToken.current {
        //            // User is logged in, use 'accessToken' here.
        //
        //        }
        
        setUpViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
    }
    
    @IBAction func termsTapped(_ sender: Any) {
        

        
        let navigationController = UINavigationController()
        navigationController.setupAppThemeNavigationBar()
        let confirmViewController = WebViewController()
        confirmViewController.isNavigation = true
        navigationController.viewControllers = [confirmViewController]
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func privacyTapped(_ sender: Any) {
        
        let navigationController = UINavigationController()
        navigationController.setupAppThemeNavigationBar()
        let confirmViewController = WebViewController()
        confirmViewController.isNavigation = true
        confirmViewController.webType = .aboutUs
        navigationController.viewControllers = [confirmViewController]
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
    //MARK: - Private Methods
    
    func homeViewPresentation() {
        Utility.setUpNavDrawerController()
        let leftMenuViewController = LeftNavDrawerViewController()
        let navController = UINavigationController()
        navController.setupAppThemeNavigationBar()
        navController.viewControllers = [Utility.tabController]
        let slideMenuController = SlideMenuController(mainViewController: navController, leftMenuViewController: leftMenuViewController)
        slideMenuController.modalPresentationStyle = .fullScreen
        self.present(slideMenuController, animated: true, completion: nil)
    }
    
    func loginManagerDidComplete(_ result: LoginResult) {
        
        self.facebookDataSource = Mapper<Facebook>().map(JSON: [:])!
        switch result {
        case .cancelled:
            print("canceled")
        case .failed(let error):
            print("faialed",error)
            
        case .success(_, _, let accessToken):
            
            print(result)
            print("\(accessToken.tokenString)")
            
            let request = GraphRequest(graphPath: "me",
                                       parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"],
                                       httpMethod: .get)
            request.start { [weak self] _, result, error in
                let field = result! as? [String:Any]
                
                if let data = Mapper<Facebook>().map(JSONObject: result) {
                    self?.facebookDataSource = data
                    self?.facebookDataSource.token = accessToken.tokenString
                    
                    let name = "\(self?.facebookDataSource.first_name) \(self?.facebookDataSource.last_name)"
                    
                    UserDefaults.standard.set(name, forKey: kUserFullName)
                    if let imageURL = ((field!["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                        print(imageURL)
                        UserDefaults.standard.set(String(imageURL), forKey: kUserSocialAvatar)
                    }
                }
                self?.FBLogin(token: accessToken.tokenString)
                
            }
            
        }
    }
    
    func FBLogin(token: String){
        Utility.showLoading(viewController: self)
        var social_email = self.facebookDataSource.email
        if social_email == "" {
            social_email = self.facebookDataSource.first_name+"@gmail.com"
        }
        APIClient.sharedClient.socialSignIn(email: social_email,full_name: self.facebookDataSource.name, social_access_token: self.facebookDataSource.token, social_id: token) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: false)
                
            } else {
                if let data = Mapper<SignUpUser>().map(JSONObject: result) {
                    self.dataSource = data
                    UserDefaults.standard.set(self.dataSource.token, forKey: kToken)
                    
                    UserDefaults.standard.set(self.dataSource.fullName, forKey: kUserFullName)
                    
                    UserDefaults.standard.set(self.dataSource.avatar, forKey: kUserAvatar)
                    
                    if(Int(self.dataSource.isActive) == 0){
                        let basicInfoViewController  = BasicInfoViewController()
                        basicInfoViewController.userId = self.dataSource.id
                        self.navigationController?.pushViewController(basicInfoViewController, animated: true)
                        
                    } else {
                        UserDefaults.standard.set(true, forKey: kUserIsSocial)
                        self.homeViewPresentation()
                    }
                }
            }
        }
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        //        self.homeViewPresentation()
        if phoneTextField.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Empty Phone Field", viewController: self, type: .error, isNavigation: false)
            return
        }
        else{
            if phoneTextField.text!.count != 12
            {
                NSError.showErrorWithMessage(message: "Invalid phone format", viewController: self, type: .error, isNavigation: false)
                return
            }
        }
        
        if passwordTextField.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Empty Password Field", viewController: self, type: .error, isNavigation: false)
            return
        }
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.logInUser(phone: phoneTextField.text!, password: passwordTextField.text!) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: false)
                
            } else {
                if let data = Mapper<SignUpUser>().map(JSONObject: result) {
                    self.dataSource = data
                    UserDefaults.standard.set(self.dataSource.token, forKey: kToken)
                    UserDefaults.standard.set(self.dataSource.billingId, forKey: kBillingId)
                    UserDefaults.standard.set(self.dataSource.shippingId, forKey: kShippingId)
                    UserDefaults.standard.set(self.dataSource.fullName, forKey: kUserFullName)
                    UserDefaults.standard.set(self.dataSource.avatar, forKey: kUserAvatar)
                    self.homeViewPresentation()
                }
            }
        }
    }
    
    @IBAction func forgetTapped(_ sender: Any) {
        self.navigationController?.pushViewController(ForgetPasswordViewController(), animated: true)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        self.navigationController?.pushViewController(SignUppViewController(), animated: true)
    }
    
    @IBAction func fbLoginTapped(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(
            permissions: [.publicProfile],
            viewController: self
        ) { result in
            self.loginManagerDidComplete(result)
        }
    }
    
    @IBAction func googleLoginTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().delegate = self
        
    }
}
extension SignInViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            
        } else {
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let email = user.profile.email
            let pic = user.profile.imageURL(withDimension: 300)
            
            APIClient.sharedClient.socialSignIn(email: email!,full_name: fullName!, social_access_token: idToken!, social_id: userId!) { (response, result, error, message) in
                Utility.hideLoading(viewController: self)
                if error != nil {
                    error?.showErrorBelowNavigation(viewController: self, isNavigation: false)
                    
                } else {
                    if let data = Mapper<SignUpUser>().map(JSONObject: result) {
                        self.dataSource = data
                        UserDefaults.standard.set(self.dataSource.token, forKey: kToken)
                        if (Int(self.dataSource.isActive) == 0) {
                            let basicInfoViewController  = BasicInfoViewController()
                            basicInfoViewController.userId = self.dataSource.id
                            self.navigationController?.pushViewController(basicInfoViewController, animated: true)
                            
                        } else {
                            UserDefaults.standard.removeObject(forKey: kUserSocialAvatar)
                            UserDefaults.standard.set(self.dataSource.fullName, forKey: kUserFullName)
                            UserDefaults.standard.set("\(pic!)", forKey: kUserSocialAvatar)
                            UserDefaults.standard.set(self.dataSource.avatar, forKey: kUserAvatar)
                            UserDefaults.standard.set(true, forKey: kUserIsSocial)
                            self.homeViewPresentation()
                        }
                    }
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print(error)
    }
}
