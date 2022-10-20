//
//  OtherCatagoriesController.swift
//  Doctoor
//
//  Created by DevBatch on 27/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class OtherCatagoriesController: UIViewController {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Variables
    
    var isPopularTest = false
    
    var isPopularServices = false
    
    var equipDataSource = [MedicalEquip]()
    
    var testDataSource = [LabCategory]()
    
    var serviceDataSource = [InDemandServices]()
    
    var cityDataSource = [CityModel]()
    
    var selectedCity = Mapper<CityModel>().map(JSON: [:])!
    
    var pageNo : Int = 1
    
    var limit : Int = 1000
    
    var offset : Int = 0 //pageNo*limit
    
    var isDataLoading : Bool = false
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isPopularTest {
            getPopularCatTest()
        }
        else if isPopularServices {
            getPopularServices(pageNo: pageNo, limit: limit)
        }
        else {
            getPopularEquip(pageNo: pageNo, limit: limit)
        }
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //MARK: - Private Methods
    
    func getPopularEquip(pageNo: Int,limit: Int) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getPopularEquip(page: pageNo, limit: limit) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<MedicalEquip>().mapArray(JSONObject: result) {
                    self.equipDataSource = data
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func getPopularCatTest() {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getPopularTest { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<LabCategory>().mapArray(JSONObject: result) {
                    self.testDataSource = data
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func getPopularServices(pageNo: Int,limit: Int){
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getPopularServices(page: pageNo, limit: limit) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<InDemandServices>().mapArray(JSONObject: result) {
                    self.serviceDataSource = data
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension OtherCatagoriesController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isPopularTest {
            return testDataSource.count
        }
        if isPopularServices {
            return serviceDataSource.count
        }
        return equipDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isPopularServices{
            let servicesCell = SquareCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
            if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(serviceDataSource[indexPath.item].image)") {
                servicesCell.catImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                })
            }
            
            servicesCell.catLabel.text = serviceDataSource[indexPath.item].serviceName
            return servicesCell
        }
        
        if isPopularTest{
            let cell = TestCategoryCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
            if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(testDataSource[indexPath.item].catImage)") {
                cell.categoryImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                })
            }
            cell.upperLabel.text = testDataSource[indexPath.item].catName
            cell.lowerLabel.text = "Test"
            return cell
        }
        
        let sqaureCell = SquareCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
        if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(equipDataSource[indexPath.item].image)") {
            sqaureCell.catImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
            })
        }
        sqaureCell.catLabel.text = equipDataSource[indexPath.item].equipName
        return sqaureCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: 181)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isPopularTest {
            let selectTestViewController = SelectTestViewController()
            selectTestViewController.addCustomBackButton()
            selectTestViewController.isOtherCat = true
            selectTestViewController.labId =  self.testDataSource[indexPath.item].labId
            selectTestViewController.catId =  self.testDataSource[indexPath.item].testCatId
            self.navigationController?.pushViewController(selectTestViewController, animated: true)
        
        } else if isPopularServices {
            
            var service = Mapper<ServiceModel>().map(JSON: [:])!
            service = serviceDataSource[indexPath.item].serviceType
            
            let navigationController = UINavigationController()
            navigationController.setupAppThemeNavigationBar()
            let selectServicesViewController = SelectServicesViewController()
            selectServicesViewController.addCustomBackButton()
            selectServicesViewController.isHisoryService = true
            selectServicesViewController.selectedCityFromHistory = serviceDataSource[indexPath.item].cityId
            
            let serviceObj = Mapper<ServiceModel>().map(JSON: [:])!
            serviceObj.serviceId = serviceDataSource[indexPath.row].serviceId
            serviceObj.serviceName = serviceDataSource[indexPath.row].serviceName
            
            selectServicesViewController.selectedServiceObj = serviceObj
            selectServicesViewController.cityId = serviceDataSource[indexPath.item].cityId
            navigationController.viewControllers = [selectServicesViewController]
            self.present(navigationController, animated: true, completion: nil)

        }
        else{
            if(self.equipDataSource[indexPath.row].isRental){
//                let serviceViewController = SelectServicesViewController()
//                serviceViewController.addCustomBackButton()
//                serviceViewController.selectedCity = self.selectedCity
//                self.navigationController?.pushViewController(serviceViewController, animated: true)
                
                let navigationController = UINavigationController()
                navigationController.setupAppThemeNavigationBar()
                let selectServicesViewController = SelectServicesViewController()
                selectServicesViewController.addCustomBackButton()
                selectServicesViewController.isHisoryService = true
                let serviceObj = Mapper<ServiceModel>().map(JSON: [:])!
                serviceObj.id = equipDataSource[indexPath.row].id
                serviceObj.equpmentName = equipDataSource[indexPath.row].equipName
                selectServicesViewController.isRental = true
                selectServicesViewController.selectedServiceObj = serviceObj
                
                
                navigationController.viewControllers = [selectServicesViewController]
                self.present(navigationController, animated: true, completion: nil)
            }
            else{
                let equipmentDetailsViewController = EquipmentDetailsViewController()
                equipmentDetailsViewController.addCustomBackButton()
                let selectedRow = self.equipDataSource[indexPath.row]
                equipmentDetailsViewController.selectedEquipment = selectedRow
                self.navigationController?.pushViewController(equipmentDetailsViewController, animated: true)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        
        
//        if isPopularServices {
//            if ((collectionView.contentOffset.y + collectionView.frame.size.height) >= collectionView.contentSize.height)
//            {
//                if !isDataLoading {
//                    isDataLoading = true
//                    self.pageNo = self.pageNo + 1
//                    getPopularServices(pageNo: self.pageNo, limit: self.limit)
//
//                }
//            }
//        }
//        if isPopularTest {
//
//        }
//        else{
//            if ((collectionView.contentOffset.y + collectionView.frame.size.height) >= collectionView.contentSize.height)
//            {
//                if !isDataLoading {
//                    isDataLoading = true
//                    self.pageNo = self.pageNo + 1
//                    getPopularEquip(pageNo: self.pageNo, limit: self.limit)
//                }
//            }
//        }
    }
}
