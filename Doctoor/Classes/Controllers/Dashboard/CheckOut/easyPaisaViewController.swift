//
//  easyPaisaViewController.swift
//  Doctoor
//
//  Created by DevBatch on 19/03/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import UIKit

import ObjectMapper

class easyPaisaViewController: UIViewController {
    
    //MARK: - Variables
    
    var totalAmount = 0.0
    
    var paymentMethod = 0
    
    var isProduct = false
    
    var COD = false
    
    var orderNumber = ""
    
    var billingModel = Mapper<UserAddress>().map(JSON: [:])!
    
    var shippingModel = Mapper<UserAddress>().map(JSON: [:])!
    
    var orderId = ""
    
    var isService = false
    
    var isRental = false
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var emailTextField: MBUITextField!{
        didSet {
            emailTextField.setIcon(#imageLiteral(resourceName: "email address-green"), width: 23, height: 20)
            emailTextField.autocapitalizationType = .none
        }
    }
    
    @IBOutlet weak var phoneNumber: MBUITextField!{
        didSet {
            phoneNumber.setIcon(#imageLiteral(resourceName: "phone-green"), width: 20, height: 20)
//            phoneNumber.isMobileNumberTextField = true
            phoneNumber.autocapitalizationType = .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()

        // Do any additional setup after loading the view.
    }
    
    func setupViewController(){
        navigationItem.title = "EasyPaisa"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
    }
    
    @IBAction func phoneNumberEditing(_ sender: Any) {
        phoneNumber.text = "03"
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        if emailTextField.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Email field is required", viewController: self, type: .error, isNavigation: true)
            return
        }
        
        if emailTextField.text!.isValidEmail()  == false {
            NSError.showErrorWithMessage(message: "Invalid Email", viewController: self, type: .error)
            return
        }
        if phoneNumber.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Empty Phone Field", viewController: self, type: .error)
            return
        }
        
        let string = phoneNumber.text!
        let output = string.dropFirst()
        let finalNumber = output.dropFirst()
        
        if finalNumber.isEmpty {
            NSError.showErrorWithMessage(message: "Empty Phone Field", viewController: self, type: .error)
            return
        }
        
        
        if self.orderId != "" {
            self.completeOrderWithEasyPaisa(paymentMethod: self.paymentMethod, orderId: self.orderId)
        }
        else{
            Utility.showLoading(viewController: self)
            APIClient.sharedClient.placeNewOrder(totalAmount: "\(totalAmount)", paymentMethod: "\(paymentMethod)", deliveryType: "2", billingModel: billingModel, shippingModel: shippingModel) { (response, result, error, message) in
                Utility.hideLoading(viewController: self)
                if error != nil {
                    error?.showErrorBelowNavigation(viewController: self)
                    
                } else {
                    print(message!)
                    
                    if let data = Mapper<OrderPlaced>().map(JSONObject: result) {
                        
                        self.orderNumber = data.orderNumber
                        self.completeOrderWithEasyPaisa(paymentMethod: self.paymentMethod, orderId: data.orderNumber)
                    }
                }
            }
        }
        
    }
    
    func completeOrderWithEasyPaisa(paymentMethod: Int, orderId: String){
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.easyPaisaPaymentAuth(orderId: "\(orderId)", totalAmount: "\(totalAmount)", mobile: phoneNumber.text!, email: emailTextField.text!) { (response, result, error, _) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
            
            } else {
                
                if let data = Mapper<EasyPaisaModel>().map(JSONObject: result) {
                    

                    switch data.respCode {
                    case "0000": //SUCCESS
                        
                        self.orderConfimationApiCall(orderNumber: orderId, status: 2, statusCode: data.respCode,statusDesc: data.respDesc)
                        
                        break;
                    case "0001": //SYSTEM ERROR
                        NSError.showErrorWithMessage(message: data.respDesc, viewController: self, type: .error)
                        break;
                    case "0002": //REQUIRED FIELD MISSING
                        NSError.showErrorWithMessage(message: "Phone number is not valid!", viewController: self, type: .error)
                        
                        break;
                    case "0005": //MERCHANT ACCOUNT NOT ACTIVE
                        NSError.showErrorWithMessage(message: "Transaction failed!", viewController: self, type: .error)
                        break;
                    case "0006": //INVALID STORE ID
                        NSError.showErrorWithMessage(message: "Transaction failed!", viewController: self, type: .error)
                        break;
                    case "0007": //STORE NOT ACTIVE
                        NSError.showErrorWithMessage(message: "Transaction failed!", viewController: self, type: .error)
                        break;
                    case "0008": //PAYMENT METHOD NOT ENABLED
                        NSError.showErrorWithMessage(message: "Transaction failed!", viewController: self, type: .error)
                        break;
                    case "0010": //INVALID CREDENTIALS
                        NSError.showErrorWithMessage(message: "Transaction failed!", viewController: self, type: .error)
                        break;
                    case "0013": //LOW BALANCE
                        NSError.showErrorWithMessage(message: data.respDesc, viewController: self, type: .error)
                        break;
                    case "0014": //ACCOUNT DOES NOT EXIST
                        NSError.showErrorWithMessage(message: data.respDesc, viewController: self, type: .error)
                        break;
                    default:
                        NSError.showErrorWithMessage(message: "Transaction failed!", viewController: self, type: .error)
                    }
                }
            }
        }
    }
    
    func orderConfimationApiCall(orderNumber: String, status: Int, statusCode: String, statusDesc: String) {
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.confirmOrder(orderNumber: orderNumber,status: status, paymentMethodId: 5, isService: self.isService,isRental: self.isRental)  { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                
                Utility.deleteAllItems()
                let alert = UIAlertController(title: "Information", message: "Thank-you, Transaction has been completed successfully!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    
                    self.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alert, animated: true)
            }
        }
    }
}
