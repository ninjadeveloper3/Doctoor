//
//  CheckoutStepTwoViewController.swift
//  Doctoor
//
//  Created by DevBatch on 25/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class CheckoutStepTwoViewController: UIViewController {
    
    //MARK: - Variables
    
    var shippingDataSource = Mapper<UserAddress>().map(JSON: [:])!
    
    var billingDataSource = Mapper<UserAddress>().map(JSON: [:])!
    
    var province = ["Punjab"]
    
    let provincePicker = UIPickerView()
    
    let cityPicker = UIPickerView()

    var dataSource = [CityModel]()

    var selectedCity = Mapper<CityModel>().map(JSON: [:])!


//    var selectedCity = Mapper<cityTextField>().map(JSON: [:])!
    
    var billingID = 0
    
    var totalAmount = 0.0
    
    var COD = false
    
    var isProduct = false
    
    var isSameBilling = false
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var FirstNameIcon: MBUITextField!{
        didSet{
            FirstNameIcon.setIcon(#imageLiteral(resourceName: "full-name"), width: 20, height: 20)
        }
    }
    @IBOutlet weak var LastNameIcon: MBUITextField!{
        didSet{
            LastNameIcon.setIcon(#imageLiteral(resourceName: "full-name"), width: 20, height: 20)
        }
    }
    @IBOutlet weak var MobileIcon: MBUITextField!{
        didSet{
            MobileIcon.setIcon(#imageLiteral(resourceName: "phone-no"), width: 20, height: 20)
            MobileIcon.isMobileNumberTextField = true
            MobileIcon.autocapitalizationType = .none
        }
    }
    @IBOutlet weak var EmailIcon: MBUITextField!{
        didSet{
            EmailIcon.setIcon(#imageLiteral(resourceName: "email-address"), width: 20, height: 20)
            EmailIcon.autocapitalizationType = .none
        }
    }
    @IBOutlet weak var AddressIcon: MBUITextField!{
        didSet{
            AddressIcon.setIcon(#imageLiteral(resourceName: "map"), width: 13, height: 16)
        }
    }
    @IBOutlet weak var ProvinceIcon: MBUITextField!{
        didSet{
            ProvinceIcon.setIcon(#imageLiteral(resourceName: "down-arrow"), width: 12, height: 7)
        }
    }
    
    @IBOutlet weak var cityTextField: MBUITextField!{
        didSet{
            self.cityTextField.setIcon(#imageLiteral(resourceName: "down-arrow"), width: 12, height: 7)
        }
    }
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
        
        self.provincePicker.delegate = self
        self.provincePicker.dataSource = self
        self.ProvinceIcon.delegate = self
        self.cityTextField.delegate = self
        
        FirstNameIcon.delegate = self
        LastNameIcon.delegate = self
    }
       
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        navigationItem.title = "Checkout"
        
        if (isSameBilling){
            doSetSameAsShipping()
        }
        else{
            if Utility.isKeyPresentInUserDefaults(key: kBillingId) {
                if let billingId = UserDefaults.standard.object(forKey: kBillingId) as? Int {
                    if billingId != 0 {
                        self.billingID = billingId
                        Utility.showLoading(viewController: self)
                        APIClient.sharedClient.getBillingDetails { (reponse, result, error, message) in
                            Utility.hideLoading(viewController: self)
                            if error != nil {
                                error?.showErrorBelowNavigation(viewController: self)
                                
                            } else {
                                if let data = Mapper<UserAddress>().map(JSONObject: result) {
                                    self.billingDataSource = data
                                    self.doSetSameAsShipping()
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        self.ProvinceIcon.inputView = self.provincePicker

    }
    
    //MARK: - Private Methods
    
    func doSetSameAsShipping(){
        if isSameBilling {
            FirstNameIcon.text = shippingDataSource.firstName
            LastNameIcon.text = shippingDataSource.lastName
            MobileIcon.text = "\(shippingDataSource.mobileNumber)"
            EmailIcon.text = shippingDataSource.email
            AddressIcon.text = shippingDataSource.address
            self.ProvinceIcon.text = shippingDataSource.province
            self.cityTextField.text = shippingDataSource.city
        }
        else{
            FirstNameIcon.text = billingDataSource.firstName
            LastNameIcon.text = billingDataSource.lastName
            MobileIcon.text = "\(billingDataSource.mobileNumber)"
            EmailIcon.text = billingDataSource.email
            AddressIcon.text = billingDataSource.address
        }
        
    }
    
    //MARK: - IBAction Methods
    
    func doGetCities(selectedProvince: String){
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getCities(province: selectedProvince) { (response, result, error, message) in
            self.dataSource.removeAll()
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<CityModel>().mapArray(JSONObject: result) {
                    self.dataSource = data
                    if self.dataSource.count == 0 {
                        self.cityTextField.text! = ""
                    }
                    self.cityPicker.delegate = self
                    self.cityPicker.dataSource = self
                    self.cityTextField.inputView = self.cityPicker
                    self.cityPicker.reloadAllComponents()
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 15
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    @IBAction func proceedButtonTapped(_ sender: Any) {
        
        if FirstNameIcon.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Please Enter First Name", viewController: self, type: .error, isNavigation: true)
            return
        }
        else{
            if FirstNameIcon.text!.count < 4 {
                NSError.showErrorWithMessage(message: "First name input length must be greater than r equal to 4 characters", viewController: self, type: .error)
                return
            }
            
            let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
            do {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                if regex.firstMatch(in: FirstNameIcon.text!, options: [], range: NSMakeRange(0, FirstNameIcon.text!.count)) != nil {
                    NSError.showErrorWithMessage(message: "First name must contain only letters!", viewController: self, type: .error)
                    return
                }
            }
            catch {
            }
        }
        
        if LastNameIcon.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Please Enter Last Name", viewController: self, type: .error, isNavigation: true)
            return
        }
        else{
            
            if LastNameIcon.text!.count < 4 {
                NSError.showErrorWithMessage(message: "First name input length must be greater than r equal to 4 characters", viewController: self, type: .error)
                return
            }
            
            let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
            do {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                if regex.firstMatch(in: LastNameIcon.text!, options: [], range: NSMakeRange(0, LastNameIcon.text!.count)) != nil {
                    NSError.showErrorWithMessage(message: "First name must contain only letters!", viewController: self, type: .error)
                    return
                }
            }
            catch {
            }
        }
        
        if MobileIcon.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Please Enter Mobile Number", viewController: self, type: .error, isNavigation: true)
            return
        }
        else{
            if MobileIcon.text!.count != 12
            {
                NSError.showErrorWithMessage(message: "Invalid phone format", viewController: self, type: .error, isNavigation: true)
                return
            }
        }
        
        if EmailIcon.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Email field is required", viewController: self, type: .error, isNavigation: true)
            return
        }
        
        if EmailIcon.text!.isValidEmail() == false {
            NSError.showErrorWithMessage(message: "Please Enter Valid Email Address", viewController: self, type: .error, isNavigation: true)
            return
        }
        
        if AddressIcon.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Please Enter Address", viewController: self, type: .error, isNavigation: true)
            return
        }
        
        if ProvinceIcon.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Please Enter Province", viewController: self, type: .error, isNavigation: true)
            return
        }
        
        if cityTextField.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Please Enter City", viewController: self, type: .error, isNavigation: true)
            return
        }
        
        if billingID == 0 {
            
            billingDataSource.firstName = FirstNameIcon.text!
            billingDataSource.lastName = LastNameIcon.text!
            billingDataSource.mobileNumber = MobileIcon.text!
            billingDataSource.email = EmailIcon.text!
            billingDataSource.address = AddressIcon.text!
            billingDataSource.city = self.cityTextField.text!
//            billingDataSource.province = ProvinceIcon.text!
        }
        
        let checkOutView = CheckoutStepThreeViewController()
        checkOutView.addCustomBackButton()
        checkOutView.totalAmount = totalAmount
        checkOutView.COD = COD
        checkOutView.isProduct = self.isProduct
        checkOutView.isService = false
        checkOutView.isRental = false
        checkOutView.billingDataSource = billingDataSource
        checkOutView.shippingDataSource = shippingDataSource
        self.navigationController?.pushViewController(checkOutView, animated: true)
    }
}

extension CheckoutStepTwoViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == provincePicker {
            return province.count
            
        }
        return self.dataSource.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if pickerView == cityPicker {
            return dataSource[row].cityName
        }
        else{
            return province[row]
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == cityPicker {
            if dataSource[row].cityName != "" {
                self.cityTextField.text = dataSource[row].cityName
            }
            
            //            self.selectedCity = dataSource[row]
        } else {
            self.ProvinceIcon.text = province[row]
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if province.contains(textField.text!){
            doGetCities(selectedProvince: textField.text!)
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == cityTextField {
            if(ProvinceIcon.text == ""){
                NSError.showErrorWithMessage(message: "Please select province first!", viewController: self, type: .error)
                textField.endEditing(true)
            }
        }
    }
}

