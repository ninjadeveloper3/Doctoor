//
//  CheckoutStepFourViewController.swift
//  Doctoor
//
//  Created by DevBatch on 25/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import WebKit
import ObjectMapper


class CheckoutStepFourViewController: UIViewController {
    
    //MARK: - Variables
    
    var totalAmount = 0.0
    
    var paymentMethod = 0
    
    var isProduct = false
    
    var COD = false
    
    var billingModel = Mapper<UserAddress>().map(JSON: [:])!
    
    var shippingModel = Mapper<UserAddress>().map(JSON: [:])!
    
    var orderId = ""
    
    var isService = false
    
    var isRental = false
    
    var easypaisaPayment = false
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var webView: WKWebView!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        navigationItem.title = "Checkout"
        webView.navigationDelegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonTappedOnBrowser(sender:)))
    }
    
    //MARK: - IBAction Methods
    
    @objc func backButtonTappedOnBrowser(sender : UIBarButtonItem) {
        
        if !self.webView.isHidden {
            let alert = UIAlertController(title: "Warning", message: "Are you sure you want to cancel payment?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
                
                
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                
            }))
            
            self.present(alert, animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    @IBAction func completeOrderButtonTapped(_ sender: Any) {
        
        if COD {
            cashOnDeliveryApi()
        }
        else{
            if orderId != "" {
                
                    if self.paymentMethod == 6 { //for easy paisa CC
                        self.completeOrderWithEasyPaisa(paymentMethod: self.paymentMethod, orderId: orderId)
                    }
                else{
                    completeOrderWithJazz(paymentMethod: paymentMethod, orderId: orderId)
                }
                
                
            }
            else{
                completeOrderApi()
            }
        }
    }
    
    func cashOnDeliveryApi(){
        
        if self.isProduct  {
            Utility.showLoading(viewController: self)
            APIClient.sharedClient.placeNewOrder(totalAmount: "\(totalAmount)", paymentMethod: "\(paymentMethod)", deliveryType: "2", billingModel: billingModel, shippingModel: shippingModel) { (response, result, error, message) in
                Utility.hideLoading(viewController: self)
                if error != nil {
                    error?.showErrorBelowNavigation(viewController: self)
                    
                } else {
                    print(message!)
                    
                    if let data = Mapper<OrderPlaced>().map(JSONObject: result) {
                        self.orderConfimationApiCall(orderNumber: data.orderNumber, status: 3)
                    }
                }
            }
            
        } else {
            //success message
            self.orderConfimationApiCall(orderNumber: self.orderId, status: 3)
//            let alert = UIAlertController(title: "Information", message: "Thank-you, We've received your request, Our representative will be in contact with you shortly.", preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
//
//                self.dismiss(animated: true, completion: nil)
//            }))
//
//            self.present(alert, animated: true)
        }
    }
    
    func completeOrderApi(){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.placeNewOrder(totalAmount: "\(totalAmount)", paymentMethod: "\(paymentMethod)", deliveryType: "2", billingModel: billingModel, shippingModel: shippingModel) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                print(message!)
                
                if let data = Mapper<OrderPlaced>().map(JSONObject: result) {
                    
                    if !self.COD {
                        
                        if self.paymentMethod == 6 { //for easy paisa CC
                            self.completeOrderWithEasyPaisa(paymentMethod: self.paymentMethod, orderId: data.orderNumber)
                        }
                        else{
                            self.completeOrderWithJazz(paymentMethod: self.paymentMethod, orderId: data.orderNumber)
                        }
                    } else {
                        self.orderConfimationApiCall(orderNumber: data.orderNumber, status: 3)
                    }
                }
            }
        }
    }
    
    func completeOrderWithJazz(paymentMethod: Int, orderId: String){
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.paymentAuth(method: "\(paymentMethod)", orderId: "\(orderId)", totalAmount: "\(totalAmount)") { (response, result, error, _) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.webView.isHidden = false
                if let url = URL(string: result as! String) {
                    let request = URLRequest(url: url)
                    self.webView.load(request)
                    self.orderId = orderId
                }
            }
        }
    }
    
    func easypaisaInquire(){
        
        var token = ""
        if Utility.isKeyPresentInUserDefaults(key: kToken) {
            token = UserDefaults.standard.object(forKey: kToken) as! String
        }
        
        // prepare json data
        let json: [String: Any] = ["orderId": "\(orderId)",
                                   "storeId": "48772", "accountNum": "110948915"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "https://easypay.easypaisa.com.pk/easypay-service/rest/v4/inquire-transaction")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("SE9NRU1FRElDU1BWVExURDoxZjNlMmRmZWNjYjQ4YTJiYTc2ZmRlMDAxZTMzMTdjYQ==", forHTTPHeaderField: "Credentials")
//        Utility.showLoading(viewController: self)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                Utility.hideLoading(viewController: self)
            }
            
            // Check for Error
            if let error = error {
                DispatchQueue.main.async {
                    NSError.showErrorWithMessage(message: "Payment failed", viewController: self, type: .error, isNavigation: false)
                }
                print("Error took place \(error)")
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                do {
                    guard let todo = try JSONSerialization.jsonObject(with: data, options: [])
                        as? [String: Any] else {
                            DispatchQueue.main.async {
                                NSError.showErrorWithMessage(message: "Transaction Failed!", viewController: self, type: .error, isNavigation: false)
                            }
                            return
                    }
                    if let _ = todo["responseCode"] {
                        print("Success")
                        if let code = todo["responseCode"] {

                            if code as? String == "0000" {
                                
                                self.orderConfimationApiCall(orderNumber: self.orderId, status: 2)
                            }
                            else{
                                let alert = UIAlertController(title: "Information", message: "Transaction failed!", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                    
                                    self.dismiss(animated: true, completion: nil)
                                }))
                                
                                self.present(alert, animated: true)
                            }
                            print(code)
                        }
                    }
                    
                } catch  {
                    print("error trying to convert data to JSON")
                    return
                }
                print("Response data string:\n \(dataString)")
            }
        }
        task.resume()
        
    }
    
    func completeOrderWithEasyPaisa(paymentMethod: Int, orderId: String){
        
        self.webView.isHidden = false
        let result = "https://mediq.com.pk:44380/api/easyPasia?amount=\(totalAmount)&orderRefNum=\(orderId)"
        if let url = URL(string: result) {
            let request = URLRequest(url: url)
            self.webView.load(request)
            self.orderId = orderId
        }
    }
    
    func orderConfimationApiCall(orderNumber: String, status: Int) {
        var paymentMethodId = 1
        if COD {
            paymentMethodId = 4
        }
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.confirmOrder(orderNumber: orderNumber,status: status, paymentMethodId: paymentMethodId, isService: self.isService,isRental: self.isRental)  { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                
                if self.easypaisaPayment {
                    Utility.deleteAllItems()
                    let alert = UIAlertController(title: "Information", message: "Thank-you, Transaction has been completed successfully!", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        
                        self.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.present(alert, animated: true)
                    
                    return
                }
                
                if self.isService || self.isRental {
                    let alert = UIAlertController(title: "Information", message: "You will receive a call from our representative shortly.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        
                        self.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.present(alert, animated: true)
                    
                    return
                }
                
                if status == 2 && !self.isService && !self.isRental {
                    
                    Utility.deleteAllItems()
                    
                    
                    let alert = UIAlertController(title: "Information", message: "Thank-you, We've received your request, Our representative will be in contact with you shortly.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        
                        self.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.present(alert, animated: true)
                    
                    return
                }
                
                if self.COD {
                    
                    let alert = UIAlertController(title: "Information", message: "Thank-you, We've received your request, Our representative will be in contact with you shortly.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        
                        self.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.present(alert, animated: true)
                    
                    if self.isProduct {
                        Utility.deleteAllItems()
                    }
                }
            }
        }
    }
}

extension CheckoutStepFourViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let host = navigationAction.request.url?.absoluteString {
            print("Host URL: \(host)")
            if host == "\(kStagingBaseUrl)paymentResponse" {
                decisionHandler(.cancel)
                
                if paymentMethod == 6 {
                    easypaisaPayment = true
                    self.easypaisaInquire()
                }
                else{
                    easypaisaPayment = false
                self.orderConfimationApiCall(orderNumber: self.orderId, status: 2)
                }
                return
            }
            
            if host == "\(kStagingBaseUrl)paymentResponseFail" {
                
                if paymentMethod == 6 {
                    NSError.showErrorWithMessage(message: "Easypaisa is unable to place your order", viewController: self, type: .error)
                }
                else{
                    NSError.showErrorWithMessage(message: "JazzCash is unable to place your order", viewController: self, type: .error)
                }
                
                
//                self.orderConfimationApiCall(orderNumber: self.orderId, status: 3)
            }
            
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Utility.hideLoading(viewController: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            Utility.hideLoading(viewController: self)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Utility.showLoading(viewController: self)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        error.showErrorBelowNavigation(viewController: self)
        Utility.hideLoading(viewController: self)
    }
}
