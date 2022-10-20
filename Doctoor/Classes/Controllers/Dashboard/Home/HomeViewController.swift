//
//  HomeViewController.swift
//  Doctoor
//
//  Created by DevBatch on 19/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ImageSlideshow
import ObjectMapper
import OneSignal

class HomeViewController: UIViewController {
    
    //MARK: - Variables
    
    var localSource = [InputSource]()
    
    var bannarDataSource = [BannarImages]()
    
    var inDemandDataSource = Mapper<InDemand>().map(JSON: [:])!
    
    var isLoadData = false
    
    var colorArray = [UIColor]()
    
    //MARK: - Outlets
    
    @IBOutlet weak var slideShow: ImageSlideshow!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var labTestView: HMView!
    
    @IBOutlet weak var pharmacyView: HMView!
    
    @IBOutlet weak var homeMedicalServiceView: HMView!
    
    @IBOutlet weak var uploadPrescriptionView: HMView!
    
    //MARK: - UIViewController Methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        bannarApiCall()
        if Utility.isKeyPresentInUserDefaults(key: kToken) {
            settingUpPlayId()
        }
        colorArray.removeAll()
        colorArray = Array(repeating: [#colorLiteral(red: 0.1578664184, green: 0.7639741302, blue: 0.873596549, alpha: 1), #colorLiteral(red: 0.1502691209, green: 0.8760904074, blue: 0.5964846611, alpha: 1), #colorLiteral(red: 0.1810388267, green: 0.2604581118, blue: 0.3767175376, alpha: 1), #colorLiteral(red: 0.5716004968, green: 0.4530112147, blue: 0.2566290498, alpha: 1)], count: 4)
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                print("App Version:\(version).\(build)")
                let alert = UIAlertController(title: "Application Information", message: "You are currently using \nApp Version:\(version) with Build no:\(build)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                    self.checkVersion()
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "", secondTitle: "mediQ")
        navLabel.attributedText = navTitle
        self.tabBarController?.navigationItem.titleView = navLabel
        
        let filterBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        filterBtn.setImage(#imageLiteral(resourceName: "cart"), for: .normal)
        filterBtn.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        filterBtn.addBadge(number: Utility.getCartItems().count) // Add Badges on Cart Buttons
        let barButton = UIBarButtonItem(customView: filterBtn)
        self.tabBarController?.navigationItem.rightBarButtonItem = barButton
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        slideShow.slideshowInterval = 5.0
        slideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        slideShow.contentScaleMode = UIViewContentMode.scaleToFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.8481271863, green: 0.1670740545, blue: 0.5549028516, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        slideShow.pageIndicator = pageControl
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let labTestGesture = UITapGestureRecognizer(target: self, action: #selector(labTestViewTapped(sender:)))
        labTestView.addGestureRecognizer(labTestGesture)
        
        let pharmacyGesture = UITapGestureRecognizer(target: self, action: #selector(pharmacyViewTapped(sender:)))
        pharmacyView.addGestureRecognizer(pharmacyGesture)
        
        let medicalServiceGesture = UITapGestureRecognizer(target: self, action: #selector(medicalServicesViewTapped(sender:)))
        homeMedicalServiceView.addGestureRecognizer(medicalServiceGesture)
        
        let uploadGesture = UITapGestureRecognizer(target: self, action: #selector(uploadViewTapped(sender:)))
        uploadPrescriptionView.addGestureRecognizer(uploadGesture)
    }
    
    //MARK: - Private Methods
    
    func settingUpPlayId() {
        
        let playerId = getPlayerID()
        APIClient.sharedClient.setDeviceId(deviceID: playerId) { (response, result, error, message) in
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
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
    
    @objc func labTestViewTapped(sender: UITapGestureRecognizer) {
        
        let navigationController = UINavigationController()
        navigationController.setupAppThemeNavigationBar()
        navigationController.viewControllers = [SelectLabViewController()]
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func pharmacyViewTapped(sender: UITapGestureRecognizer) {
        
        let navigationController = UINavigationController()
        navigationController.setupAppThemeNavigationBar()
        navigationController.viewControllers = [SelectCategoryViewController()]
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func medicalServicesViewTapped(sender: UITapGestureRecognizer) {
        
        let navigationController = UINavigationController()
        navigationController.setupAppThemeNavigationBar()
        navigationController.viewControllers = [MedicalServicesViewController()]
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func uploadViewTapped(sender: UITapGestureRecognizer) {
        if Utility.isKeyPresentInUserDefaults(key: kToken) {
            let navigationController = UINavigationController()
            navigationController.setupAppThemeNavigationBar()
            navigationController.viewControllers = [PerscriptionViewController()]
            self.present(navigationController, animated: true, completion: nil)
            
        } else {
            let moveToLoginViewController = MoveToLoginViewController()
            moveToLoginViewController.modalPresentationStyle = .overCurrentContext
            self.present(moveToLoginViewController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func fabButtonTapped(_ sender: Any) {
        Utility.dialNumber()
    }
    
    func bannarApiCall() {
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getBanner { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.localSource.removeAll()
                if let data = Mapper<BannarImages>().mapArray(JSONObject: result){
                    self.bannarDataSource = data
                    for bannarData in  self.bannarDataSource {
                        self.localSource.append(KingfisherSource(urlString: "\(kBannerImageDownloadBaseUrl)storage/\(bannarData.file)")!)
                    }
                    self.slideShow.setImageInputs(self.localSource)
                    self.inDemandApiCall()
                }
            }
        }
    }
    
    func inDemandApiCall() {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getInDemandProduct { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<InDemand>().map(JSONObject: result) {
                    self.inDemandDataSource = data
                    self.collectionView.reloadData()
                    self.isLoadData = true
                    self.colorArray.removeAll()
                    self.colorArray = Array(repeating: [#colorLiteral(red: 0.1578664184, green: 0.7639741302, blue: 0.873596549, alpha: 1), #colorLiteral(red: 0.1502691209, green: 0.8760904074, blue: 0.5964846611, alpha: 1), #colorLiteral(red: 0.1810388267, green: 0.2604581118, blue: 0.3767175376, alpha: 1), #colorLiteral(red: 0.5716004968, green: 0.4530112147, blue: 0.2566290498, alpha: 1)], count: self.inDemandDataSource.tests.count)
                }
            }
        }
    }
    
    func checkVersion() {
        
        APIClient.sharedClient.checkApiVersion { (response, result, error, message) in
            if error != nil {
                //                error?.showServerErrorInViewController(self)
                
            } else {
                if let data = Mapper<VersionModel>().map(JSONObject: result) {
                    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                            if data.ios != "\(version).\(build)" {
                                print("API Version:\(data.ios)")
                                print("App Version:\(version).\(build)")
                                let moveToLoginViewController = MoveToLoginViewController()
                                moveToLoginViewController.isVersionCheck = true
                                moveToLoginViewController.modalPresentationStyle = .overCurrentContext
                                self.present(moveToLoginViewController, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func getPlayerID() -> String {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let userID = status.subscriptionStatus.userId
        print("userID = \(userID ?? "No Id")")
        UserDefaults.standard.set("\(userID ?? "No Id")", forKey: kDeviceToken)
        return "\(userID ?? "No Id")"
    }
}

// MARK: - UICollectionView Delegate & DataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoadData {
            let dataCount = self.inDemandDataSource.equipments.count + self.inDemandDataSource.tests.count + self.inDemandDataSource.medicines.count
            return dataCount
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let medEquCount = self.inDemandDataSource.equipments.count + self.inDemandDataSource.medicines.count
        if indexPath.row < self.inDemandDataSource.equipments.count { // Equiment Check
            let cell = InDemandCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
            if self.inDemandDataSource.equipments.count > 0 {
                cell.firstTitleLabel.text = "Equiment"
                cell.secondTitleLabel.text = inDemandDataSource.equipments[indexPath.row].equipName
                let imageUrl = inDemandDataSource.equipments[indexPath.row].image
                let imageurl = imageUrl.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
                if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(imageurl)") {
                    cell.logoImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                }
            }
            return cell
        }
        if  indexPath.row >= self.inDemandDataSource.equipments.count && indexPath.row < medEquCount { // Medicine Check
            let cell = InDemandCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
            if self.inDemandDataSource.medicines.count > 0 {
                let equCount = indexPath.row - self.inDemandDataSource.equipments.count
                cell.firstTitleLabel.text = "Medicine"
                cell.secondTitleLabel.text = inDemandDataSource.medicines[equCount].medicineName
                let imageUrl = inDemandDataSource.medicines[equCount].medicineImage
                let imageurl = imageUrl.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
                if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(imageurl)") {
                    
                    cell.logoImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                }
                return cell
            }
        }
        
        if indexPath.row >= medEquCount { // Lab Test Check
            let testCell = InDemandTestCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
            if self.inDemandDataSource.tests.count > 0 {
                testCell.firstLabel.text = "Lab Test"
                testCell.secondLabel.text = inDemandDataSource.tests[indexPath.row - medEquCount].testName
                let imageUrl = inDemandDataSource.tests[indexPath.row - medEquCount].logo
                let imageurl = imageUrl.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
                if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(imageurl)") {
                    testCell.logoImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                }
            }
            testCell.backView.backgroundColor = colorArray[indexPath.row - medEquCount]
            return testCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140 , height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let medEquCount = self.inDemandDataSource.equipments.count + self.inDemandDataSource.medicines.count
        if indexPath.row < self.inDemandDataSource.equipments.count { // Equiment Check
            
            let equipmentDetailsViewController = EquipmentDetailsViewController()
            equipmentDetailsViewController.selectedEquipment = inDemandDataSource.equipments[indexPath.row]
            equipmentDetailsViewController.isHome = true
            let navigationController = UINavigationController()
            navigationController.setupAppThemeNavigationBar()
            navigationController.viewControllers = [equipmentDetailsViewController]
            self.present(navigationController, animated: true, completion: nil)
        }
        
        if  indexPath.row >= self.inDemandDataSource.equipments.count && indexPath.row < medEquCount { // Medicine Check
            let equCount = indexPath.row - self.inDemandDataSource.equipments.count
            let medicineDetailViewController = MedicalDetailsViewController()
            medicineDetailViewController.dataSource = inDemandDataSource.medicines[equCount]
            medicineDetailViewController.isHome = true
            let navigationController = UINavigationController()
            navigationController.setupAppThemeNavigationBar()
            navigationController.viewControllers = [medicineDetailViewController]
            self.present(navigationController, animated: true, completion: nil)
        }
        
        if indexPath.row >= medEquCount { // Lab Test Check
            
            let testDetailsViewController = TestDetailsViewController()
            testDetailsViewController.itemImageUrl = inDemandDataSource.tests[indexPath.row - medEquCount].logo
            testDetailsViewController.itemTitle = inDemandDataSource.tests[indexPath.row - medEquCount].testName
            testDetailsViewController.itemPrice = inDemandDataSource.tests[indexPath.row - medEquCount].price
            testDetailsViewController.itemDescription = inDemandDataSource.tests[indexPath.row - medEquCount].description
            testDetailsViewController.colorView = colorArray[indexPath.row - medEquCount]
            testDetailsViewController.isHome = true
            testDetailsViewController.dataSource = inDemandDataSource.tests[indexPath.row - medEquCount]
            let navigationController = UINavigationController()
            navigationController.setupAppThemeNavigationBar()
            navigationController.viewControllers = [testDetailsViewController]
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}

