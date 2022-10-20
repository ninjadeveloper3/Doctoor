//
//  ConfirmSelectionViewController.swift
//  Doctoor
//
//  Created by DevBatch on 25/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

protocol ConfirmSelectionViewControllerDelegate {
    func didConfirmViewController()
}

class ConfirmSelectionViewController: UIViewController {
    
    //MARK: - Variables
    
    var totalAmount : Double = 0
    
    var deliveryChargesIncludedTotal : Double = 0
    
    var isDeliveryChargesAdded = false
    
    var isHome = false
    
    var cartOrders = [CartOrder]()
    
    var delegate: ConfirmSelectionViewControllerDelegate?
    
    //MARK: - Outlets
    
    @IBOutlet weak var cartTableView: UITableView!
    
    @IBOutlet weak var checkoutView: UIView!
    
    @IBOutlet weak var shoppingView: UIView!
    
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var cuoponCodeTextInput: UITextField!
    
    @IBOutlet weak var applyBtn: UIButton!
    
    @IBOutlet weak var applyButtonView: HMView!
    
    @IBOutlet weak var deliveryChargesLabel: UILabel!
    
    @IBOutlet weak var cancelOrderBtn: UIButton!
    
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setUpViewController()
        if cartOrders.count == 0 {
            cancelOrderBtn.isEnabled = false
        }
        else{
            cancelOrderBtn.isEnabled = true
        }
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        cartTableView.delegate = self
        cartTableView.dataSource = self
        deliveryChargesLabel.isHidden = true
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "Confirm ", secondTitle: "Selection")
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
        cartTableView.estimatedRowHeight = 100
        cartTableView.separatorStyle = .none
        if(totalAmount <= 3000.00 && totalAmount > 0){
            deliveryChargesLabel.isHidden = false
        
        } else{
            deliveryChargesLabel.isHidden = true
        }
        let myDouble = totalAmount
        let doubleStr = String(format: "%.2f", myDouble) // "3.14"
        totalPrice.text! = "\(doubleStr)"
        let checkOutGesture = UITapGestureRecognizer(target: self, action: #selector(checkOutViewTapped(sender:)))
        checkoutView.addGestureRecognizer(checkOutGesture)
        
        let shoppingGesture = UITapGestureRecognizer(target: self, action: #selector(shoppingViewTapped(sender:)))
        shoppingView.addGestureRecognizer(shoppingGesture)
        
        if isHome {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        }
        cartOrders.removeAll()
        reloadView()
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.uploadImageComplete), name: NSNotification.Name(rawValue: kUploadImageNotification), object: nil)
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func cancelOrderTapped(_ sender: Any) {
        print("cancel order")
        if cartOrders.count == 0 {
            cancelOrderBtn.isEnabled = false
        }
        else{
            cancelOrderBtn.isEnabled = false
            Utility.deleteAllItems()
            reloadView()
        }
        
    }
    
    
    @IBAction func applyTapped(_ sender: Any) {
        if(cuoponCodeTextInput.text!.isEmpty){
            NSError.showErrorWithMessage(message: "Cuopon Field is empty", viewController: self, type: .error, isNavigation: false)
            return
        }
        
        Utility.showLoading(viewController: self)
        var cuopon = cuoponCodeTextInput.text!
        cuopon = cuopon.replacingOccurrences(of: " ", with: "%20")
        APIClient.sharedClient.applyCuoponCode(cuoponCode: cuopon) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                var displayamount = ""
                if let data  = result!["percentage"] {
                    self.totalAmount = Utility.percentageToValue(percent: data as! Double, amount: self.deliveryChargesIncludedTotal)
                    self.deliveryChargesIncludedTotal = self.totalAmount
                    displayamount = String(format: "%.2f", self.deliveryChargesIncludedTotal)
                    self.totalPrice.text! = "\(displayamount)"
                    self.cuoponCodeTextInput.isUserInteractionEnabled = false
                    self.applyBtn.isUserInteractionEnabled = false
                    self.applyButtonView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                }
            }
        }
    }
    
    
    @IBAction func callButtonTapped(_ sender: Any) {
        Utility.dialNumber()
    }
    
    
    //MARK: - Private Methods
    
    @objc func backButtonTapped(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func uploadImageComplete(notification: NSNotification){
        
        confirmationSuccess()
    }
    
    @objc func checkOutViewTapped(sender: UITapGestureRecognizer){
        
        if Utility.isKeyPresentInUserDefaults(key: kToken) {
            
            var prepCount = 0
            
            for cartItem in cartOrders {
                if cartItem.isPrescription == 1 {
                    prepCount += 1
                }
            }
            
            if prepCount > 0 {
                
                let navigationController = UINavigationController()
                navigationController.setupAppThemeNavigationBar()
                let perscriptionViewController = PerscriptionViewController()
                perscriptionViewController.isConfirmationOrder = true
                perscriptionViewController.prescFor = "medicine"
                navigationController.viewControllers = [perscriptionViewController]
                self.present(navigationController, animated: true, completion: nil)
                return
            }
            
            confirmationSuccess()
            
        } else {
            let moveToLoginViewController = MoveToLoginViewController()
            moveToLoginViewController.modalPresentationStyle = .overCurrentContext
            self.present(moveToLoginViewController, animated: true, completion: nil)
        }
    }
    
    @objc func shoppingViewTapped(sender: UITapGestureRecognizer){
        
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name(kNNotificationIdentifier), object: nil, userInfo: nil)
    }
    
    func reloadView() {
        cartOrders = Utility.getCartItems()
        totalAmount = 0.0
        deliveryChargesIncludedTotal = 0.0
        for item in cartOrders {
            totalAmount += Double(item.price * Double(item.quantity))
        }
        deliveryChargesIncludedTotal = totalAmount
        if(totalAmount <= 3000.00 && totalAmount > 0) {
            deliveryChargesLabel.isHidden = false
            if !isDeliveryChargesAdded {
                deliveryChargesIncludedTotal = totalAmount + kAdditionalDelieveryCharges
                isDeliveryChargesAdded = true
            }
        }
        else{
            deliveryChargesLabel.isHidden = true
        }
        let myDouble = deliveryChargesIncludedTotal
        let doubleStr = String(format: "%.2f", myDouble) // "3.14"
        totalPrice.text! = "\(doubleStr)"
        self.cartTableView.reloadData()
        
        if cartOrders.count == 0 {
            NSError.showErrorWithMessage(message: "Cart is Empty", viewController: self, type: .info, isNavigation: true)
        }
    }
    
    func confirmationSuccess() {
        if Utility.getCartItems().count == 0 {
            NSError.showErrorWithMessage(message: "Please add some items in the cart to checkout", viewController: self, type: .error, isNavigation: true)
            return
        }
        var cod = false
        let checkOutViewController = CheckoutStepOneViewController()
        checkOutViewController.addCustomBackButton()
        checkOutViewController.totalAmount = deliveryChargesIncludedTotal
        if totalAmount > kJazzCashLimit {
            cod = true
        }
        checkOutViewController.COD = cod
        checkOutViewController.isProduct = true
        self.navigationController?.pushViewController(checkOutViewController, animated: true)
    }
}

extension ConfirmSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CartTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        let quantityBasedPrice = "\(cartOrders[indexPath.row].price * Double(cartOrders[indexPath.row].quantity))"
        let stringToInt = Double(quantityBasedPrice)
        
        let itemIntPrice = stringToInt
        let itemTotalPrice = String(format: "%.2f", itemIntPrice!) // "3.14"
        
        cell.itemPrice.text = "\(itemTotalPrice)"
        cell.titleCartLabel.text = cartOrders[indexPath.row].title
        
        let myDouble = cartOrders[indexPath.row].price
        let doubleStr = String(format: "%.2f", myDouble) // "3.14"
        
        cell.singleItemPrice = Double(doubleStr) as! Double
        cell.itemQuantity.text = "\(cartOrders[indexPath.row].quantity)"
        cell.selectedQty = cartOrders[indexPath.row].quantity
        
        if cartOrders[indexPath.row].productType == ProductType.Test.rawValue {
            cell.descriptionLabel.isHidden = false
        }
        
        if cartOrders[indexPath.row].productType == ProductType.Medicine.rawValue {
            cell.descriptionLabel.text = "Medicine"
        }
        
        if cartOrders[indexPath.row].productType == ProductType.Equipment.rawValue {
            cell.descriptionLabel.text = cartOrders[indexPath.row].productDescription != "" ? cartOrders[indexPath.row].productDescription : "Medical Equiement"
        }
        
        cell.delegate = self
        return cell
    }
}

extension ConfirmSelectionViewController : CartTableViewCellDelegate {
    func didDeleteOrder(cell: CartTableViewCell) {
        if let indexPath = cartTableView.indexPath(for: cell) {
            Utility.deleteInCart(id: cartOrders[indexPath.row].id)
        }
        isDeliveryChargesAdded = false
        reloadView()
    }
    
    func didIncrementOrder(cell: CartTableViewCell) {
        if let indexPath = cartTableView.indexPath(for: cell) {
            Utility.incrementInCart(id: cartOrders[indexPath.row].id)
            totalAmount += Double(cell.singleItemPrice)
            deliveryChargesIncludedTotal += Double(cell.singleItemPrice)
            if (totalAmount <= 3000.00 && totalAmount > 0){
                deliveryChargesLabel.isHidden = false
                
                if !isDeliveryChargesAdded {
                    deliveryChargesIncludedTotal = totalAmount + kAdditionalDelieveryCharges
                    isDeliveryChargesAdded = true
                }
            }
            else{
                deliveryChargesLabel.isHidden = true
                if isDeliveryChargesAdded {
                    deliveryChargesIncludedTotal = deliveryChargesIncludedTotal - kAdditionalDelieveryCharges
                    isDeliveryChargesAdded = false
                }
            }
            let myDouble = deliveryChargesIncludedTotal
            let doubleStr = String(format: "%.2f", myDouble) // "3.14"
            totalPrice.text! = "\(doubleStr)"
        }
    }
    
    func didDecrementOrder(cell: CartTableViewCell) {
        if let indexPath = cartTableView.indexPath(for: cell) {
            if cartOrders[indexPath.row].quantity != 1 {
                Utility.decrementInCart(id: cartOrders[indexPath.row].id)
                totalAmount -= Double(cell.singleItemPrice)
                deliveryChargesIncludedTotal -= Double(cell.singleItemPrice)
                if (totalAmount <= 3000.00 && totalAmount > 0){
                    deliveryChargesLabel.isHidden = false
                    
                    if !isDeliveryChargesAdded {
                        deliveryChargesIncludedTotal = totalAmount + kAdditionalDelieveryCharges
                        isDeliveryChargesAdded = true
                    }
                }
                else{
                    deliveryChargesLabel.isHidden = true
                    if isDeliveryChargesAdded {
                        deliveryChargesIncludedTotal = deliveryChargesIncludedTotal - kAdditionalDelieveryCharges
                        isDeliveryChargesAdded = false
                    }
                }
                let myDouble = deliveryChargesIncludedTotal
                let doubleStr = String(format: "%.2f", myDouble) // "3.14"
                totalPrice.text! = "\(doubleStr)"
            }
        }
    }
}
