//
//  NewPasswordViewController.swift
//  Doctoor
//
//  Created by Zeeshan Haider on 23/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import ObjectMapper


class NewPasswordViewController: UIViewController {
    
    //MARK: - Variables
    
    var userId = 0
    var countdownTimer: Timer!
    var totalTime = 5
    var isTimerRunning = false
    var dataSource = Mapper<SignUpUser>().map(JSON: [:])!
    
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var resendBtn: UIButton!
    
    @IBOutlet weak var verificationCode: MBUITextField!{
        didSet {
            verificationCode.setIcon(#imageLiteral(resourceName: "password"), width: 20, height: 20)
            verificationCode.autocapitalizationType = .none
        }
    }
    @IBOutlet weak var confirmPassIcon: MBUITextField!{
        didSet {
            confirmPassIcon.setIcon(#imageLiteral(resourceName: "password"), width: 20, height: 20)
            confirmPassIcon.autocapitalizationType = .none
        }
    }
    @IBOutlet weak var newPassword: MBUITextField!{
        didSet {
            newPassword.setIcon(#imageLiteral(resourceName: "password"), width: 20, height: 20)
            newPassword.autocapitalizationType = .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    func setUpViewController() {
        resendBtn.layer.cornerRadius = 5.0
        resendBtn.layer.masksToBounds = true
        resendBtn.isEnabled = false
    }
    
    @objc func updateTime() {
        
        if resendBtn.isEnabled {
            resendBtn.isEnabled = false
        }
        print(timeFormatted(totalTime))
        resendBtn.setTitle("Resend "+timeFormatted(totalTime), for: .normal)
        
        if totalTime != 0 {
            totalTime -= 1
            
        } else {
            endTimer()
        }
    }
    func endTimer() {
        resendBtn.isEnabled = true
        countdownTimer.invalidate()
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    //MARK: - Private Methods
    
    func doResendApiCall() {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.resendActivationCode(userId: userId) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: false)
                
            } else {
                NSError.showErrorWithMessage(message: "Verification code has been resent"
                    , viewController: self, type: .success, isNavigation: false)
            }
        }
    }
    
    func gotoDashboard(){
        Utility.setUpNavDrawerController()
        let leftMenuViewController = LeftNavDrawerViewController()
        let navController = UINavigationController()
        navController.setupAppThemeNavigationBar()
        navController.viewControllers = [Utility.tabController]
        
        let slideMenuController = SlideMenuController(mainViewController: navController, leftMenuViewController: leftMenuViewController)
        self.present(slideMenuController, animated: true, completion: nil)
    }
    
    @IBAction func resendBtnTapped(_ sender: Any) {
        print("resend tapped")
        totalTime = 5
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        doResendApiCall()
    }
    
    
    @IBAction func onSubmit(_ sender: Any) {
        
        if verificationCode.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Verification code field cannot be empty", viewController: self, type: .error, isNavigation: false)
            return
        }
        if confirmPassIcon.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Confirm Password field cannot be empty", viewController: self, type: .error, isNavigation: false)
            return
        }
        if newPassword.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Password field cannot be empty", viewController: self, type: .error, isNavigation: false)
            return
        }
        if newPassword.text != confirmPassIcon.text {
            NSError.showErrorWithMessage(message: "Password and confirm password  does not matched", viewController: self, type: .error, isNavigation: false)
            return
        }
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.doSetNewPass(userId: userId, code: verificationCode.text!, password: newPassword.text!){ (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: false)
                
            } else {
                
                if let data = Mapper<SignUpUser>().map(JSONObject: result) {
                    self.dataSource = data
                    UserDefaults.standard.set(self.dataSource.token, forKey: kToken)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
}
