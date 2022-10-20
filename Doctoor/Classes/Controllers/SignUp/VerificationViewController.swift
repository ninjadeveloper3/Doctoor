//
//  VerificationViewController.swift
//  Doctoor
//
//  Created by DevBatch on 19/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import ObjectMapper


class VerificationViewController: UIViewController {
    
    //MARK: - Variables
    
    var dataSource = Mapper<SignUpUser>().map(JSON: [:])!
    var isPassword = false
    var userId = 0
    var countdownTimer: Timer!
    var totalTime = 60
    var isTimerRunning = false
    
    //MARK: - IBOutlets
    
    
    @IBOutlet weak var resendButton: UIButton!
    
    @IBOutlet weak var verificationCodetextField: MBUITextField!
    
    @IBOutlet weak var verficationCode: MBUITextField!{
        didSet {
            verficationCode.setIcon(#imageLiteral(resourceName: "varification code"), width: 20, height: 20)
        }
    }
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
        
        setUpViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        print("userId = ",userId)
        resendButton.layer.cornerRadius = 5.0
        resendButton.layer.masksToBounds = true
        resendButton.isEnabled = false
    }
    
    //MARK: - Private Methods
    
    @objc func updateTime() {
        
        if resendButton.isEnabled {
            resendButton.isEnabled = false
        }
        resendButton.setTitle("Resend "+timeFormatted(totalTime), for: .normal)
        
        if totalTime != 0 {
            totalTime -= 1
            
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        resendButton.isEnabled = true
        countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func doResendApiCall() {
        APIClient.sharedClient.resendActivationCode(userId: userId) { (response, result, error, message) in
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: false)
                
            } else {
                NSError.showErrorWithMessage(message: "Verification code has been resent"
                    , viewController: self, type: .success, isNavigation: false)
            }
        }
    }
    
    func navigateToDashboard() {
        Utility.setUpNavDrawerController()
        let leftMenuViewController = LeftNavDrawerViewController()
        let navController = UINavigationController()
        navController.setupAppThemeNavigationBar()
        navController.viewControllers =
            [Utility.tabController]
        let slideMenuController = SlideMenuController(mainViewController: navController, leftMenuViewController: leftMenuViewController)
        slideMenuController.modalPresentationStyle = .fullScreen
        self.present(slideMenuController, animated: true, completion: nil)
    }
    
    //MARK: - IBAction Methods
    
    
    @IBAction func resendButtonTapped(_ sender: Any) {
        totalTime = 60
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        doResendApiCall()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
//        self.navigateToDashboard()
        if (isPassword){
            self.navigationController?.pushViewController(NewPasswordViewController(), animated: true)
            
        } else {
            
            if verificationCodetextField.text!.isEmpty {
                NSError.showErrorWithMessage(message: "Empty Code Field", viewController: self, type: .error, isNavigation: false)
                return
            }
            Utility.showLoading(viewController: self)
            APIClient.sharedClient.accountVerify(userId: userId, code: verificationCodetextField.text!) { (response, result, error, message) in
                Utility.hideLoading(viewController: self)
                if error != nil {
                    error?.showErrorBelowNavigation(viewController: self, isNavigation: false)
                    
                } else {
                    if let data = Mapper<SignUpUser>().map(JSONObject: result) {
                        self.dataSource = data
                        UserDefaults.standard.set(self.dataSource.token, forKey: kToken)
                        
                        UserDefaults.standard.set(self.dataSource.fullName, forKey: kUserFullName)
                        
                        UserDefaults.standard.set(self.dataSource.avatar, forKey: kUserAvatar)
                        
                        //Navigation to dashboard
                        self.navigateToDashboard()
                    }
                }
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}
