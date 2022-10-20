//
//  SignUppViewController.swift
//  Doctoor
//
//  Created by DevBatch on 19/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper
import SlideMenuControllerSwift
import FacebookLogin
import FacebookCore
import Firebase
import GoogleSignIn

class SignUppViewController: UIViewController,UITextFieldDelegate {
    
    //MARK: - Variables
    
    var dataSource = Mapper<SignUpUser>().map(JSON: [:])!
    
    var facebookDataSource = Mapper<Facebook>().map(JSON: [:])!
    
    var segmentedControl: GLXSegmentedControl!
    
    var margin: CGFloat = 10.0
    
    var segmentCount = 0
    
    let datePicker = UIDatePicker()
    
    var isLogin = true
    
    
    @IBOutlet weak var fullNameTextField: MBUITextField!{
        didSet {
            fullNameTextField.setIcon(#imageLiteral(resourceName: "full-name"), width: 20, height: 20)
        }
    }
    
    @IBOutlet weak var emailTextField: MBUITextField!{
        didSet {
            emailTextField.setIcon(#imageLiteral(resourceName: "email-address"), width: 23, height: 20)
            emailTextField.autocapitalizationType = .none
        }
    }
    
    @IBOutlet weak var phoneTextField: MBUITextField!{
        didSet {
            phoneTextField.setIcon(#imageLiteral(resourceName: "phone-no"), width: 20, height: 20)
            phoneTextField.isMobileNumberTextField = true
        }
    }
    
    @IBOutlet weak var passwordTextField: MBUITextField!{
        didSet {
            passwordTextField.setIcon(#imageLiteral(resourceName: "password"), width: 20, height: 20)
        }
    }
    
    @IBOutlet weak var segmentView: UIView!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullNameTextField.delegate = self
        setUpViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        let appearance = GLXSegmentAppearance()
        appearance.segmentOnSelectionColor = #colorLiteral(red: 0.9332318306, green: 0.9333917499, blue: 0.933221817, alpha: 1)
        
        appearance.segmentOffSelectionColor = UIColor.white
        appearance.titleOnSelectionFont = UIFont.systemFont(ofSize: 15.0)
        appearance.titleOffSelectionFont = UIFont.systemFont(ofSize: 15.0)
        appearance.contentVerticalMargin = 10.0
        appearance.dividerColor =  .lightGray
        appearance.titleOnSelectionColor = .black
        appearance.titleOffSelectionColor = .black
        var width = self.segmentView.frame.size.width + (self.segmentView.frame.size.width * 0.13)
        if !Utility.isiphoneX() {
            width = self.segmentView.frame.width
        }
        
        if Utility.isiphone6Plus() {
             width = self.segmentView.frame.size.width + (self.segmentView.frame.size.width * 0.13)
        }
        
        let segmentFrame = CGRect(x: 0, y: 0, width: width, height: self.segmentView.frame.size.height)
        self.segmentedControl = GLXSegmentedControl(frame: segmentFrame, segmentAppearance: appearance)
//        self.segmentedControl.frame =  CGRect(x: 0, y: 0, width: width, height: self.segmentView.frame.size.height)
        self.segmentedControl.backgroundColor = UIColor.clear
        
        self.segmentedControl.layer.cornerRadius = 5.0
        self.segmentedControl.layer.borderColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        self.segmentedControl.layer.borderWidth = 1.0
        
        self.segmentedControl.addSegment(withTitle:"Male", onSelectionImage: #imageLiteral(resourceName: "male"), offSelectionImage:  #imageLiteral(resourceName: "male"))
        self.segmentedControl.addSegment(withTitle:"Female", onSelectionImage:  #imageLiteral(resourceName: "female"), offSelectionImage:  #imageLiteral(resourceName: "female"))
        
        
        segmentCount = 2
        self.segmentedControl.addTarget(self, action: #selector(self.selectSegmentInsegmentedControl(segmentedControl:)), for: .valueChanged)
        
        // Set segment with index 0 as selected by default
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentView.addSubview(self.segmentedControl)
        
        phoneTextField.textContentType = .username
        passwordTextField.textContentType = .password
    }
    
    //MARK: - Private Methods
    
    @objc func selectSegmentInsegmentedControl(segmentedControl: GLXSegmentedControl) {
        print("Select segment at index: \(segmentedControl.selectedSegmentIndex)")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 200
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
//    func firstCharacterUppercaseString(string: String) -> String {
//        var str = string as NSString
//        let firstUppercaseCharacter = str.substring(to: 1).uppercased
//        let firstUppercaseCharacterString = str.replacingCharacters(in: NSMakeRange(0, 1), with: firstUppercaseCharacter())
//        return firstUppercaseCharacterString
//    }
    
    //MARK: - IBAction Methods
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        if fullNameTextField.text!.isEmpty{
            NSError.showErrorWithMessage(message: "Empty Name Field", viewController: self, type: .error, isNavigation: false)
            return
        }
        else{
            
            if fullNameTextField.text!.count < 4 {
                NSError.showErrorWithMessage(message: "Full name input length must be greater than r equal to 4 characters", viewController: self, type: .error, isNavigation: false)
                return
            }
            
            let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
            do {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                if regex.firstMatch(in: fullNameTextField.text!, options: [], range: NSMakeRange(0, fullNameTextField.text!.characters.count)) != nil {
                    NSError.showErrorWithMessage(message: "Full name must contain only letters!", viewController: self, type: .error, isNavigation: false)
                    return
                }
            }
            catch {
                
            }

        }
        
        if emailTextField.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Email field is required", viewController: self, type: .error, isNavigation: false)
            return
        }
        
        if emailTextField.text!.isValidEmail()  == false {
            NSError.showErrorWithMessage(message: "Invalid Email", viewController: self, type: .error, isNavigation: false)
            return
        }
        
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
            NSError.showErrorWithMessage(message: "Password field is required", viewController: self, type: .error, isNavigation: false)
            return
        }
        
        if passwordTextField.text!.count < 8 {
            NSError.showErrorWithMessage(message: "Password must be 8 character long", viewController: self, type: .error, isNavigation: false)
            return
        }
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.signUpUser(fullName: fullNameTextField.text!, email: emailTextField.text!, phone: phoneTextField.text!, password: passwordTextField.text!, gender: segmentedControl.selectedSegmentIndex == 0 ? "male" : "female") { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: false)
                
            } else {
                if let data = Mapper<SignUpUser>().map(JSONObject: result) {
                    self.dataSource = data
                    let verificationViewController = VerificationViewController()
                    verificationViewController.userId = self.dataSource.id
                    self.navigationController?.pushViewController(verificationViewController, animated: true)
                }
            }
        }
    }
    
    @IBAction func siginButtonTapped(_ sender: Any) {
        
        if isLogin {
            self.navigationController?.popViewController(animated: true)
            
        } else {
            self.navigationController?.pushViewController(SignInViewController(), animated: true)
        }
        
    }
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
    
    func loginManagerDidComplete(_ result: LoginResult) {
        
        self.facebookDataSource = Mapper<Facebook>().map(JSON: [:])!
        switch result {
        case .cancelled:
            print("canceled")
            
        case .failed(let error):
            print("faialed",error)
            
        case .success( _, _, let accessToken):
            
            print("success",result)
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
                    if(Int(self.dataSource.isActive) == 0){
                        let basicInfoViewController  = BasicInfoViewController()
                        basicInfoViewController.userId = self.dataSource.id
                        self.navigationController?.pushViewController(basicInfoViewController, animated: true)
                    
                    } else {
                        UserDefaults.standard.set(self.dataSource.fullName, forKey: kUserFullName)
                        UserDefaults.standard.set(self.dataSource.avatar, forKey: kUserAvatar)
                        UserDefaults.standard.set(true, forKey: kUserIsSocial)
                        self.homeViewPresentation()
                    }
                }
            }
        }
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
    
    @IBAction func googleSignupTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().delegate = self
    }
    
    
    @IBAction func termsButtonTapped(_ sender: Any) {
    }
    
    @IBAction func privacyPolicyButtonTapped(_ sender: Any) {
    }
}
extension SignUppViewController: GIDSignInDelegate {
    
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
