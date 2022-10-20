//
//  CheckoutStepOneViewController.swift
//  Doctoor
//
//  Created by DevBatch on 25/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class CheckoutStepOneViewController: UIViewController {
    
    //MARK: - Variables
    
    var shippingDataSource = Mapper<UserAddress>().map(JSON: [:])!
    
    let provincePicker = UIPickerView()
    
    let cityPicker = UIPickerView()
    
    var dataSource = [CityModel]()
    
    var province = ["Punjab"]
    
    var selectedCity = Mapper<CityModel>().map(JSON: [:])!
    
    var shippingID = 0
    
    var totalAmount = 0.0
    
    var COD = false
    
    var isProduct = false
    
    var sameBillingAddress = false
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var NameFieldIcon: MBUITextField!{
        didSet{
            NameFieldIcon.setIcon(#imageLiteral(resourceName: "full-name"), width: 20, height: 20)
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
    
    @IBOutlet weak var emailIcon: MBUITextField!{
        didSet{
            emailIcon.setIcon(#imageLiteral(resourceName: "email-address"), width: 20, height: 20)
            emailIcon.autocapitalizationType = .none
        }
    }
    
    @IBOutlet weak var addressIcon: MBUITextField!{
        didSet{
            addressIcon.setIcon(#imageLiteral(resourceName: "map"), width: 13, height: 16)
        }
    }
    
    @IBOutlet weak var provinceIcon: MBUITextField!{
        didSet{
            provinceIcon.setIcon(#imageLiteral(resourceName: "down-arrow"), width: 12, height: 7)
        }
    }
    
    
    @IBOutlet weak var CityIcon: MBUITextField!{
        didSet{
            CityIcon.setIcon(#imageLiteral(resourceName: "down-arrow"), width: 12, height: 7)
        }
    }
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
        //        doGetCities()
        self.provincePicker.delegate = self
        self.provincePicker.dataSource = self
        self.cityPicker.delegate = self
        self.cityPicker.dataSource = self
        
        self.CityIcon.delegate = self
        self.provinceIcon.delegate = self
        
        NameFieldIcon.delegate = self
        LastNameIcon.delegate = self
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        navigationItem.title = "Checkout"
        
        if Utility.isKeyPresentInUserDefaults(key: kShippingId) {
            if let shippingId = UserDefaults.standard.object(forKey: kShippingId) as? Int{
                if shippingId != 0 {
                    self.shippingID = shippingId
                    Utility.showLoading(viewController: self)
                    APIClient.sharedClient.getShippingDetails { (response, result, error, message) in
                        Utility.hideLoading(viewController: self)
                        if error != nil {
                            error?.showErrorBelowNavigation(viewController: self)
                            
                        } else {
                            if let data = Mapper<UserAddress>().map(JSONObject: result) {
                                self.shippingDataSource = data
                                self.NameFieldIcon.text! = self.shippingDataSource.firstName
                                self.LastNameIcon.text! = self.shippingDataSource.lastName
                                self.MobileIcon.text! = self.shippingDataSource.mobileNumber
                                self.emailIcon.text! = self.shippingDataSource.email
                                self.provinceIcon.text = self.province.first
                                self.CityIcon.text! = self.shippingDataSource.city
                                self.addressIcon.text! = self.shippingDataSource.address
                            }
                        }
                    }
                }
            }
        }
        self.provinceIcon.inputView = self.provincePicker
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func checkboxTapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sameBillingAddress = false
            sender.setImage(#imageLiteral(resourceName: "box"), for: .normal)
            
        } else {
            sender.isSelected = true
            sameBillingAddress = true
            sender.setImage(#imageLiteral(resourceName: "selected box"), for: .normal)
        }
    }
    
    
    @IBAction func checkOutButtonTapped(_ sender: Any) {
        
        if NameFieldIcon.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Please Enter First Name", viewController: self, type: .error)
            return
        }
        else{
            
            if NameFieldIcon.text!.count < 4 {
                NSError.showErrorWithMessage(message: "First name input length must be greater than r equal to 4 characters", viewController: self, type: .error)
                return
            }
            
            let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
            do {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                if regex.firstMatch(in: NameFieldIcon.text!, options: [], range: NSMakeRange(0, NameFieldIcon.text!.count)) != nil {
                    NSError.showErrorWithMessage(message: "First name must contain only letters!", viewController: self, type: .error)
                    return
                }
            }
            catch {
                
            }
            
        }
        
        if LastNameIcon.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Please Enter Last Name", viewController: self, type: .error)
            return
        }
        else{
            
            if LastNameIcon.text!.count < 4 {
                NSError.showErrorWithMessage(message: "Last name input length must be greater than r equal to 4 characters", viewController: self, type: .error)
                return
            }
            
            let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
            do {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                if regex.firstMatch(in: LastNameIcon.text!, options: [], range: NSMakeRange(0, LastNameIcon.text!.count)) != nil {
                    NSError.showErrorWithMessage(message: "Last name must contain only letters!", viewController: self, type: .error)
                    return
                }
            }
            catch {
                
            }
            
        }
        
        
        if MobileIcon.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Please Enter Mobile Number", viewController: self, type: .error)
            return
        }
        else{
            if MobileIcon.text!.count != 12
            {
                NSError.showErrorWithMessage(message: "Invalid phone format", viewController: self, type: .error)
                return
            }
        }
        
        if emailIcon.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Email field is required", viewController: self, type: .error)
            return
        }
        
        if emailIcon.text!.isValidEmail() == false {
            NSError.showErrorWithMessage(message: "Please Enter Valid Email Address", viewController: self, type: .error)
            return
        }
        
        if addressIcon.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Please Enter Address", viewController: self, type: .error)
            return
        }
        
        if provinceIcon.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Please Enter Province", viewController: self, type: .error)
            return
        }
        
        if CityIcon.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Please Enter City", viewController: self, type: .error)
            return
        }
        
        if shippingID == 0 {
            
            shippingDataSource.firstName = NameFieldIcon.text!
            shippingDataSource.lastName = LastNameIcon.text!
            //            shippingDataSource.mobileNumber = MobileIcon.text!
            shippingDataSource.email = emailIcon.text!
            shippingDataSource.address = addressIcon.text!
            shippingDataSource.city = CityIcon.text!
            shippingDataSource.province = provinceIcon.text!
        }
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.addShippingInfo(firstName: NameFieldIcon.text!, lastName: LastNameIcon.text!, phone: MobileIcon.text!, address: addressIcon.text!, province: provinceIcon.text!, email: emailIcon.text!, city: CityIcon.text!) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
            } else {
                if let data = Mapper<UserAddress>().map(JSONObject: result) {
                    let checkOutView = CheckoutStepTwoViewController()
                    checkOutView.addCustomBackButton()
                    checkOutView.totalAmount = self.totalAmount
                    checkOutView.COD = self.COD
                    checkOutView.isProduct = self.isProduct
                    checkOutView.shippingDataSource = data
                    checkOutView.isSameBilling = self.sameBillingAddress
                    self.navigationController?.pushViewController(checkOutView, animated: true)
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 15
        if addressIcon == textField{
           maxLength = 150
        }
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
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
                        self.CityIcon.text! = ""
                    }
                    self.cityPicker.delegate = self
                    self.cityPicker.dataSource = self
                    self.CityIcon.inputView = self.cityPicker
                    self.cityPicker.reloadAllComponents()
                }
            }
        }
    }
}

extension CheckoutStepOneViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
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
                self.CityIcon.text = dataSource[row].cityName
            }
    
        } else {
            self.provinceIcon.text = province[row]
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if province.contains(textField.text!){
            doGetCities(selectedProvince: textField.text!)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == CityIcon {
            if(provinceIcon.text == ""){
                NSError.showErrorWithMessage(message: "Please select province first!", viewController: self, type: .error)
                textField.endEditing(true)
            }
        }
    }
}
