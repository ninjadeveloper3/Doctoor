//
//  SelectServicesViewController.swift
//  Doctoor
//
//  Created by DevBatch on 25/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class SelectServicesViewController: UIViewController {
    
    //MARK: - Variables
    
    var selectedCity = Mapper<CityModel>().map(JSON: [:])!
    
    var serviceDataSource = [ServiceModel]()
    
    var selectedService = Mapper<ServiceModel>().map(JSON: [:])!
    
    var selectedCityFromHistory = 0
    
    var cityId = 1
    
    var selectedServiceObj = Mapper<ServiceModel>().map(JSON: [:])!
    
    var isHisoryService = false
    
    var isRental = false
    
    var serviceComments = ""
    
    let servicePicker = UIPickerView()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var cityName: MBUITextField!{
        didSet{
            self.cityName.setIcon(#imageLiteral(resourceName: "down-arrow"), width: 12, height: 7)
        }
    }
    
    @IBOutlet weak var textView: UITextView!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    override func viewWillAppear(_ animated: Bool) {
        let filterBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        filterBtn.setImage(#imageLiteral(resourceName: "cart"), for: .normal)
        filterBtn.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        filterBtn.addBadge(number: Utility.getCartItems().count)
        let barButton = UIBarButtonItem(customView: filterBtn)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func setUpViewController() {
        
        textView.layer.cornerRadius = 8.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        
        let navLabel = UILabel()
        if isRental {
            let navTitle = Utility.attributedTitle(firstTitle: "Select ", secondTitle: "Equipment")
            navLabel.attributedText = navTitle
            navigationItem.titleView = navLabel
            cityName.placeholder = "Select Equipment for Rental"
        }
        else{
            let navTitle = Utility.attributedTitle(firstTitle: "Select ", secondTitle: "Services")
            navLabel.attributedText = navTitle
            navigationItem.titleView = navLabel
        }
        
        if isHisoryService {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
            self.cityName.text = selectedServiceObj.serviceName
            self.cityId = selectedServiceObj.serviceId
            self.textView.text = serviceComments
        }
        if isRental {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
            self.cityName.text = selectedServiceObj.equpmentName
            self.cityId = selectedServiceObj.id
        }
        let filterBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        filterBtn.setImage(#imageLiteral(resourceName: "cart"), for: .normal)
        filterBtn.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        filterBtn.addBadge(number: Utility.getCartItems().count)
        let barButton = UIBarButtonItem(customView: filterBtn)
        self.navigationItem.rightBarButtonItem = barButton
        
        if isRental { //add a flag of rental in existing api if it is a rental equipement
            getRentalServices()
        }
        else{
            serviceOrderApiCall()
        }

        
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        if Utility.isKeyPresentInUserDefaults(key: kToken) {
            if textView.text.isEmpty {
                NSError.showErrorWithMessage(message: "Please Add Some Comments!", viewController: self, type: .error, isNavigation: true)
                return
            }
            else{
                
                if Utility.isKeyPresentInUserDefaults(key: kToken) {
                    
                    if isRental{
                        rentalServiceApi()
                    }
                    else{
                        Utility.showLoading(viewController: self)
                        APIClient.sharedClient.submitOrderService(cityId: self.cityId, serviceId: self.selectedService.serviceId, comments: textView.text!) { (response, result, error, message)  in
                            if error != nil {
                                Utility.hideLoading(viewController: self)
                                error?.showErrorBelowNavigation(viewController: self, isNavigation: true)
                                
                            } else {
                                Utility.hideLoading(viewController: self)
                                NSError.showErrorWithMessage(message: "Thank-you, You will receive a call from our representative shortly.", viewController: self, type: .success, isNavigation: true)
                                Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.dismissModel), userInfo: nil, repeats: true)
                                
                            }
                        }
                    }
                    
                }
                else{
                    let moveToLoginViewController = MoveToLoginViewController()
                    moveToLoginViewController.modalPresentationStyle = .overCurrentContext
                    self.present(moveToLoginViewController, animated: true, completion: nil)
                }
            }
        }
        else{
            NSError.showErrorWithMessage(message: "Please login first to place an order!", viewController: self, type: .success, isNavigation: true)
            return
        }
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem){
        if isHisoryService {
            self.dismiss(animated: true, completion: nil)
        
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Private Methods
    
    func rentalServiceApi(){
        
        print(self.selectedService.id)
        
        if self.selectedService.id == 0 {
            
            NSError.showErrorWithMessage(message: "Please select service first", viewController: self, type: .error, isNavigation: true)
            
            return
        }
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.submitRentalOrderService(cityId: self.cityId,equipmentId: self.selectedService.id,comments: textView.text!) { (response, result, error, message)  in
            if error != nil {
                Utility.hideLoading(viewController: self)
                error?.showErrorBelowNavigation(viewController: self, isNavigation: true)
                
            } else {
                Utility.hideLoading(viewController: self)
                NSError.showErrorWithMessage(message: "Thank-you, You will receive a call from our representative shortly.", viewController: self, type: .success, isNavigation: true)
                Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.dismissModel), userInfo: nil, repeats: true)
                
            }
        }
    }
    
    func serviceOrderApiCall() {
        
        serviceDataSource.removeAll()
        cityId = selectedCity.id
        
        if selectedCityFromHistory != 0 {
            cityId = selectedCityFromHistory
        }
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.serviceOrder(cityId: cityId) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<ServiceModel>().mapArray(JSONObject: result) {
                    self.serviceDataSource = data
                    if self.serviceDataSource.count > 0 {
                        self.servicePicker.delegate = self
                        self.servicePicker.dataSource = self
                        self.cityName.inputView = self.servicePicker
                        
                        if self.selectedCityFromHistory != 0 {
                            if self.isRental{
                                self.cityName.text = self.selectedServiceObj.equpmentName
                                self.selectedService = self.selectedServiceObj
                            }
                            else{
                                self.cityName.text = self.selectedServiceObj.serviceName
                                self.selectedService = self.selectedServiceObj
                            }
                            
                        }
                        else{
                            self.cityName.text = self.serviceDataSource[0].serviceName
                            self.selectedService = self.serviceDataSource[0]
                        }
                        
                    } else {
                        self.cityName.text = "No Service"
                        self.cityName.isUserInteractionEnabled = false
                    }
                }
            }
        }
    }
    
    func getRentalServices() {
        
        serviceDataSource.removeAll()
        cityId = selectedCity.id
        
        if selectedCityFromHistory != 0 {
            cityId = selectedCityFromHistory
        }
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.rentalServiceOrder(cityId: cityId) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<ServiceModel>().mapArray(JSONObject: result) {
                    self.serviceDataSource = data
                    if self.serviceDataSource.count > 0 {
                        self.servicePicker.delegate = self
                        self.servicePicker.dataSource = self
                        self.cityName.inputView = self.servicePicker
                        
                        if self.selectedCityFromHistory != 0 {
                            if self.isRental{
                                self.cityName.text = self.selectedServiceObj.equpmentName
                                self.selectedService = self.selectedServiceObj
                            }
                            else{
                                self.cityName.text = self.selectedServiceObj.serviceName
                                self.selectedService = self.selectedServiceObj
                            }
                            
                        }
                        else{
                            if self.isRental {
                                self.cityName.text = self.selectedServiceObj.equpmentName
                                let serviceObj = Mapper<ServiceModel>().map(JSON: [:])!
                                serviceObj.serviceId = self.serviceDataSource[0].id
                                serviceObj.serviceName = self.serviceDataSource[0].equpmentName
                                self.selectedService = serviceObj
                            }
                            else{
                                self.cityName.text = self.serviceDataSource[0].equpmentName
                                let serviceObj = Mapper<ServiceModel>().map(JSON: [:])!
                                serviceObj.serviceId = self.serviceDataSource[0].id
                                serviceObj.serviceName = self.serviceDataSource[0].equpmentName
                                self.selectedService = serviceObj
                            }
                            
                        }
                        
                    } else {
                        self.cityName.text = "No Service"
                        self.cityName.isUserInteractionEnabled = false
                    }
                }
            }
        }
    }
    
    @objc func addTapped(sender: UIBarButtonItem) {
//        if Utility.getCartItems().count > 0 {
        let navigationController = UINavigationController()
        navigationController.setupAppThemeNavigationBar()
        let confirmViewController = ConfirmSelectionViewController()
        confirmViewController.isHome = true
        navigationController.viewControllers = [confirmViewController]
        self.present(navigationController, animated: true, completion: nil)
//        }
    }
    
    @IBAction func fabButtonTapped(_ sender: Any) {
        Utility.dialNumber()
    }
    
    @objc func dismissModel()
    {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- PickerView Delegate & DataSource

extension SelectServicesViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return serviceDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isRental{
        return serviceDataSource[row].equpmentName
        }
        return serviceDataSource[row].serviceName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isRental{
            self.cityName.text = serviceDataSource[row].equpmentName
            self.selectedService = serviceDataSource[row]
        }
        else{
            self.cityName.text = serviceDataSource[row].serviceName
            self.selectedService = serviceDataSource[row]
        }
        
    }
}
