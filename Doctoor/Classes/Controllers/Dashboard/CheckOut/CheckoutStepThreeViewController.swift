//
//  CheckoutStepThreeViewController.swift
//  Doctoor
//
//  Created by DevBatch on 25/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class CheckoutStepThreeViewController: UIViewController {
    
    //MARK: - Variables
    
    var shippingDataSource = Mapper<UserAddress>().map(JSON: [:])!
    
    var billingDataSource = Mapper<UserAddress>().map(JSON: [:])!
    
    var totalAmount = 0.0
    
    var COD = false
    
    var easyPaisaCCPayment = false
    
    var isProduct = false
    
    var notificationData = Mapper<Notifications>().map(JSON: [:])!
    
    var isPresented = false
    
    var isService = false
    
    var isRental = false
    
    
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var mobileAccountView: HMView!
    
    @IBOutlet weak var cardAcceptLabel: UILabel!
    
//    @IBOutlet weak var voucherView: HMView!
    
    @IBOutlet weak var easyPaisaView: HMView!
    
    @IBOutlet weak var ccCardView: HMView!
    
    @IBOutlet weak var codLabel: UILabel!
    
    @IBOutlet weak var paymentImage: UIImageView!
    
    @IBOutlet weak var cashOnDeliveryCardView: HMView!
    
    @IBOutlet weak var easyPaisaCC: HMView!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        voucherView.isHidden = true
//        ccCardView.isHidden = true
        // Do any additional setup after loading the view.
        
        setUpViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        navigationItem.title = "Checkout"
        
        if (COD){
            
            codLabel.text = "Cash on delivery"
            paymentImage.image = #imageLiteral(resourceName: "Cash_on_delivery-512")
//            voucherView.isHidden = true
            ccCardView.isHidden = true
            easyPaisaView.isHidden = true
            easyPaisaCC.isHidden = true
            cardAcceptLabel.isHidden = true
            cashOnDeliveryCardView.isHidden = true
        }
        
        if isPresented {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        }
        let mobileAccountViewGesture = UITapGestureRecognizer(target: self, action: #selector(mobileAccountViewTapped(sender:)))
        mobileAccountView.addGestureRecognizer(mobileAccountViewGesture)
        
        let easyPaisaCCViewGesture = UITapGestureRecognizer(target: self, action: #selector(easyPaisaCCViewTapped(sender:)))
        easyPaisaCC.addGestureRecognizer(easyPaisaCCViewGesture)
        
        let easyPaisaViewGesture = UITapGestureRecognizer(target: self, action: #selector(easyPaisaViewTapped(sender:)))
        easyPaisaView.addGestureRecognizer(easyPaisaViewGesture)

        let ccCardViewGesture = UITapGestureRecognizer(target: self, action: #selector(ccCardViewTapped(sender:)))
        ccCardView.addGestureRecognizer(ccCardViewGesture)
        
        let codCardViewGesture = UITapGestureRecognizer(target: self, action: #selector(codCardViewTapped(sender:)))
        cashOnDeliveryCardView.addGestureRecognizer(codCardViewGesture)
    }
    
    //MARK: - Private Methods
    
    @objc func mobileAccountViewTapped(sender: UITapGestureRecognizer) {
        if COD {
            placeNewOrder(paymentMethod: 4)
        }
        else{
            placeNewOrder(paymentMethod: 1)
        }
    }
    
//    @objc func voucherViewTapped(sender: UITapGestureRecognizer) {
//        placeNewOrder(paymentMethod: 2)
//    }

    
    @objc func easyPaisaViewTapped(sender: UITapGestureRecognizer) {
        
        let paymentMethod = 5
        
        let checkOutView = easyPaisaViewController()
        checkOutView.addCustomBackButton()
        checkOutView.paymentMethod = paymentMethod
        checkOutView.totalAmount = totalAmount
        checkOutView.billingModel = billingDataSource
        checkOutView.shippingModel = shippingDataSource
        checkOutView.COD = COD
        checkOutView.isProduct = isProduct
        checkOutView.isService = self.isService
        checkOutView.isRental = self.isRental
        checkOutView.orderId = self.notificationData.orderId
        self.navigationController?.pushViewController(checkOutView, animated: true)
    }

    
    @objc func ccCardViewTapped(sender: UITapGestureRecognizer) {
        placeNewOrder(paymentMethod: 3)
    }
    
    @objc func easyPaisaCCViewTapped(sender: UITapGestureRecognizer) {
        placeNewOrder(paymentMethod: 6)
    }
    
    @objc func codCardViewTapped(sender: UITapGestureRecognizer) { //cash on delivery card view in case of amount < 50,000
        COD = true
        placeNewOrder(paymentMethod: 4)
    }
    
    func placeNewOrder(paymentMethod: Int) {
        
//        if COD {
//            cashOnDeliveryApi(paymentMethod: paymentMethod)
//        }
//        else{
            //
            self.completePayment(paymentMethod: paymentMethod)
//        }
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    func cashOnDeliveryApi(paymentMethod: Int){
    
        if isProduct {
            Utility.showLoading(viewController: self)
            APIClient.sharedClient.placeNewOrder(totalAmount: "\(totalAmount)", paymentMethod: "\(paymentMethod)", deliveryType: "2", billingModel: billingDataSource, shippingModel: shippingDataSource) { (response, result, error, message) in
                Utility.hideLoading(viewController: self)
                if error != nil {
                    error?.showErrorBelowNavigation(viewController: self)
                    
                } else {
                    print(message!)
                    
                    if let data = Mapper<OrderPlaced>().map(JSONObject: result) {
                        
                        NSError.showErrorWithMessage(message: message!, viewController: self, type: .success, isNavigation: false)
                        
                        Utility.deleteAllItems()
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                }
            }
        }
        else{
            //success message
        }
        print("success popup")
    }
    
    func completePayment(paymentMethod: Int) {
        
        let checkOutView = CheckoutStepFourViewController()
//        checkOutView.addCustomBackButton()
        checkOutView.paymentMethod = paymentMethod
        checkOutView.totalAmount = totalAmount
        checkOutView.billingModel = billingDataSource
        checkOutView.shippingModel = shippingDataSource
        checkOutView.COD = COD
        checkOutView.isProduct = isProduct
        checkOutView.isService = self.isService
        checkOutView.isRental = self.isRental
        checkOutView.orderId = self.notificationData.orderId
        self.navigationController?.pushViewController(checkOutView, animated: true)
    }
}
