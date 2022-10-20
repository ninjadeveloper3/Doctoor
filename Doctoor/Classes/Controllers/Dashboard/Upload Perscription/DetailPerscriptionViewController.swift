//
//  DetailPerscriptionViewController.swift
//  Doctoor
//
//  Created by DevBatch on 25/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class DetailPerscriptionViewController: UIViewController,UITextFieldDelegate {
    
    //MARK: - Variables 
    
    var perscriptionImage : UIImage!
    
    var isConfirmationOrder = false
    
    var prescFor = "manual"
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var fullnameTextField: MBUITextField!{
        didSet {
            fullnameTextField.setIcon(#imageLiteral(resourceName: "full-name"), width: 20, height: 20)
        }
    }
    
    @IBOutlet weak var mobileTextField: MBUITextField!{
        didSet {
            mobileTextField.setIcon(#imageLiteral(resourceName: "phone-no"), width: 20, height: 20)
            mobileTextField.isMobileNumberTextField = true
            mobileTextField.autocapitalizationType = .none
        }
    }
    
    @IBOutlet weak var emailTextField: MBUITextField!{
        didSet {
            emailTextField.setIcon(#imageLiteral(resourceName: "email-address"), width: 23, height: 20)
            emailTextField.autocapitalizationType = .none
        }
    }
    
    @IBOutlet weak var prescriptionBackImageView: UIImageView!
    
    @IBOutlet weak var prescriptionImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "Upload ", secondTitle: "Prescription")
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
        prescriptionBackImageView.image = perscriptionImage
        prescriptionImageView.image = perscriptionImage
        
        fullnameTextField.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 15
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        if fullnameTextField.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Please Enter Name", viewController: self, type: .error, isNavigation: true)
            return
        }
        
        else{
            if fullnameTextField.text!.count < 4 {
                NSError.showErrorWithMessage(message: "Full name input length must be greater than or equal to 4 characters", viewController: self, type: .error, isNavigation: true)
                return
            }
            let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
            do {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                if regex.firstMatch(in: fullnameTextField.text!, options: [], range: NSMakeRange(0, fullnameTextField.text!.count)) != nil {
                    NSError.showErrorWithMessage(message: "Full name must contain only letters!", viewController: self, type: .error, isNavigation: true)
                    return
                }
            }
            catch {
                
            }
            
        }
        
        
        if mobileTextField.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Please Phone Number", viewController: self, type: .error, isNavigation: true)
            return
        }
        else{
            if mobileTextField.text!.count != 12
            {
                NSError.showErrorWithMessage(message: "Invalid phone format", viewController: self, type: .error, isNavigation: true)
                return
            }
        }
        
        if emailTextField.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Email field is required", viewController: self, type: .error, isNavigation: true)
            return
        }
        
        if emailTextField.text!.isValidEmail() == false {
            NSError.showErrorWithMessage(message: "Please enter a valid Email Address", viewController: self, type: .error, isNavigation: true)
            return
        }
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.uploadPerscription(fullName: fullnameTextField.text!, phoneNumber: mobileTextField.text!, email: emailTextField.text!, image: perscriptionImage, prescriptionFor: self.prescFor) { (result) in
            Utility.hideLoading(viewController: self)
            if !result {
                NSError.showErrorWithMessage(message: "Prescription uploaded failed!", viewController: self, type: .error, isNavigation: true)
                
            } else {
                NSError.showErrorWithMessage(message: "Prescription uploaded successfully!", viewController: self, type: .success, isNavigation: true)
                let seconds = 2.0
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.dismiss(animated: true, completion: nil)
                    if self.isConfirmationOrder {
                        NotificationCenter.default.post(name: Notification.Name(kUploadImageNotification), object: nil, userInfo: nil)
                    }
                }
            }
        }
    }
}
