//
//  ForgetPasswordViewController.swift
//  Doctoor
//
//  Created by Zeeshan Haider on 23/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class ForgetPasswordViewController: UIViewController {

    //MARK: - Variables
    
    
    
    //MARK: - Outlets

    var dataSource = Mapper<SignUpUser>().map(JSON: [:])!
    @IBOutlet weak var phoneTextField: MBUITextField!{
        didSet {
             phoneTextField.setIcon(#imageLiteral(resourceName: "phone-no"), width: 20, height: 20)
             phoneTextField.isMobileNumberTextField = true
            phoneTextField.autocapitalizationType = .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Private Methods
    func navigateTo(userId: Int) {
        let verificationViewController  = NewPasswordViewController()
        verificationViewController.userId = userId
        self.navigationController?.pushViewController(verificationViewController, animated: true)
    }
    
    //MARK: - IBAction Methods

    @IBAction func submitTapped(_ sender: MBButton) {
        
        if phoneTextField.text!.isEmpty{
            NSError.showErrorWithMessage(message: "Please Enter Your Phone Number First", viewController: self, type: .error, isNavigation: false)
            return
        }
        else{
            if phoneTextField.text!.count != 12
            {
                NSError.showErrorWithMessage(message: "Invalid phone format", viewController: self, type: .error, isNavigation: false)
                return
            }
        }
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.forgotPassword(phone: phoneTextField.text!) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: false)
                
            } else {
                if let data = Mapper<SignUpUser>().map(JSONObject: result) {
                    self.dataSource = data
                    UserDefaults.standard.set(self.dataSource.toJSONString(), forKey: kToken)
                    self.navigateTo(userId: self.dataSource.id)
                }
            }
        }
    }
    
    @IBAction func backPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
