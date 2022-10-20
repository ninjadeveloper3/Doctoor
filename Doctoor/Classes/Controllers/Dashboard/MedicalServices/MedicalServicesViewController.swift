//
//  MedicalServicesViewController.swift
//  Doctoor
//
//  Created by Zeeshan Haider on 24/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class MedicalServicesViewController: UIViewController {
    
    //MARK: - Variables
    
    let cityPicker = UIPickerView()
    
    var dataSource = [CityModel]()
    
    var selectedCity = Mapper<CityModel>().map(JSON: [:])!
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var locationSelectionInput: UITextField!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationItem.title = "City"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        setUpViewController()
    }
    
    //MARK: - Setup Controller Methods
    
    func setUpViewController(){
        doGetCities()
    }
    
    //MARK: - Private Methods
    
    func doGetCities(){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getCities(province: "") { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<CityModel>().mapArray(JSONObject: result) {
                    self.dataSource = data
                    if self.dataSource.count > 0 {
                        self.cityPicker.delegate = self
                        self.cityPicker.dataSource = self
                        self.locationSelectionInput.inputView = self.cityPicker
                        self.locationSelectionInput.text = self.dataSource[0].cityName
                        self.selectedCity = self.dataSource[0]
                    }
                }
            }
        }
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getStartedButtonTapped(_ sender: Any) {
        
        if locationSelectionInput.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Please Select City First!", viewController: self, type: .error, isNavigation: true)
            return
        
        } else {
            let serviceTypeViewController = ServiceTypesViewController()
            serviceTypeViewController.addCustomBackButton()
            serviceTypeViewController.selectedCity = self.selectedCity
            self.navigationController?.pushViewController(serviceTypeViewController, animated: true)
        }
    }
    
    @IBAction func fabButtonTapped(_ sender: Any) {
        Utility.dialNumber()
    }
    
    
}

//MARK:- PickerView Delegate & DataSource

extension MedicalServicesViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row].cityName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.locationSelectionInput.text = dataSource[row].cityName
        self.selectedCity = dataSource[row]
    }
}
