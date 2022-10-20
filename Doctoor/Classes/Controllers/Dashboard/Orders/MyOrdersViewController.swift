//
//  MyOrdersViewController.swift
//  Doctoor
//
//  Created by DevBatch on 20/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class MyOrdersViewController: UIViewController {
    
    //MARK: - Variables
    
    let refreshControl = UIRefreshControl()
    
    var isService = false
    
    var isLabTestApi = false
    
    var isEquiment = false
    
    var isEquimentApi = false
    
    var isMedicalService = false
    
    var isMedicalServiceApi = false
    
    var isRental = false
    
    var filterButton = UIButton()
    
    var isDataLoading:Bool=false
    
    var pageNo:Int=1
    
    var limit:Int=20
    
    var offset:Int=0 //pageNo*limit
    
    var dataSource = Mapper<OrderHistory>().mapArray(JSONArray: [[:]])
    
    var serviceDataSource = Mapper<ServiceOrderHistory>().mapArray(JSONArray: [[:]])
    
    var rentalDataSource = Mapper<MedicalRentalEquip>().mapArray(JSONArray: [[:]])
    
    var isPullToRefresh = false
    
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var myOrdersTableView: UITableView!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "My ", secondTitle: "Orders")
        navLabel.attributedText = navTitle
        self.tabBarController?.navigationItem.titleView = navLabel
        filterButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        filterButton.setImage(#imageLiteral(resourceName: "cart"), for: .normal)
        filterButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        filterButton.addBadge(number: Utility.getCartItems().count)
        let barButton = UIBarButtonItem(customView: filterButton)
        self.tabBarController?.navigationItem.rightBarButtonItem = barButton
        
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        myOrdersTableView.refreshControl = refreshControl
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        self.dataSource.removeAll()
        self.serviceDataSource.removeAll()
        self.myOrdersTableView.separatorStyle = .none
        if Utility.isKeyPresentInUserDefaults(key: kToken){
            if(isService){
                getServiceHistroyApiCall(pageNo: pageNo, limit: limit)
            }
            if isRental {
                rentalDataSource.removeAll()
                getRentalServices(pageNo: pageNo, limit: limit)
            
            } else {
                getOrderHistroyApiCall(pageNo: pageNo, limit: limit)
            }
            
        } else{
            NSError.showErrorWithMessage(message: "Please login first to see your order history", viewController: self, type: .error, isNavigation: true)
        }
    }
    
    //MARK: - Private Methods
    
    @objc private func refreshWeatherData(_ sender: Any) {
       
        pageNo = 1
        limit = 20
        self.isPullToRefresh = true
        if Utility.isKeyPresentInUserDefaults(key: kToken) {
            if(isService){
//                self.serviceDataSource.removeAll()
                getServiceHistroyApiCall(pageNo: pageNo, limit: limit)
            } else if isRental{
//                self.rentalDataSource.removeAll()
                getRentalServices(pageNo: pageNo, limit: limit)
                
            } else {
//                dataSource.removeAll()
                getOrderHistroyApiCall(pageNo: pageNo, limit: limit)
            }
        }
        else{
            NSError.showErrorWithMessage(message: "Please login first to see your order history", viewController: self, type: .error, isNavigation: true)
        }
    }
    
    func getOrderHistroyApiCall(pageNo: Int, limit: Int) {
        
        if !isPullToRefresh {
            Utility.showLoading(viewController: self)
        }
        APIClient.sharedClient.getOrderHistroy(page: pageNo, limit: limit) { (response, result, error, message) in
            if !self.isPullToRefresh {
                Utility.hideLoading(viewController: self)
            } else {
                self.refreshControl.endRefreshing()
//                self.isPullToRefresh = false
            }
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<OrderHistory>().mapArray(JSONObject: result) {
                    if self.isPullToRefresh {
                        self.isPullToRefresh = false
                        self.dataSource.removeAll()
                    }
                    if data.count > 0 {
                        self.dataSource.append(contentsOf: data)
                        
                        if self.dataSource.count > 0 {
                            self.myOrdersTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func getServiceHistroyApiCall(pageNo: Int, limit: Int){
        if !isPullToRefresh {
            Utility.showLoading(viewController: self)
        }
        APIClient.sharedClient.getServiceHistroy(page: pageNo, limit: limit) { (response, result, error, message) in
            if !self.isPullToRefresh {
                Utility.hideLoading(viewController: self)
            } else {
                self.refreshControl.endRefreshing()
                
            }
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<ServiceOrderHistory>().mapArray(JSONObject: result) {
                    if self.isPullToRefresh {
                        self.isPullToRefresh = false
                        self.serviceDataSource.removeAll()
                    }
                    if data.count > 0 {
                        self.serviceDataSource.append(contentsOf: data)
                    
                        self.myOrdersTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func getRentalServices(pageNo: Int, limit: Int){
        if !isPullToRefresh {
            Utility.showLoading(viewController: self)
        }
        APIClient.sharedClient.getRentalServices(page: pageNo, limit: limit) { (response, result, error, message) in
            if !self.isPullToRefresh {
                Utility.hideLoading(viewController: self)
            } else {
                self.refreshControl.endRefreshing()
//                self.isPullToRefresh = false
            }
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<MedicalRentalEquip>().mapArray(JSONObject: result) {
                    if self.isPullToRefresh {
                        self.isPullToRefresh = false
                        self.rentalDataSource.removeAll()
                    }
                    if data.count > 0 {
                        self.rentalDataSource.append(contentsOf: data)
                        
                        self.myOrdersTableView.reloadData()
                    }
                    else{
                        
                    }
                }
            }
        }
    }
    
    @IBAction func fabTapped(_ sender: Any) {
        Utility.dialNumber()
    }
    
    
    @objc func addTapped(sender: UIBarButtonItem){
        print("My Cart")
//        if Utility.getCartItems().count > 0 {
            let navigationController = UINavigationController()
            navigationController.setupAppThemeNavigationBar()
            let confirmViewController = ConfirmSelectionViewController()
            confirmViewController.isHome = true
            navigationController.viewControllers = [confirmViewController]
            self.present(navigationController, animated: true, completion: nil)
//        }
    }
    
    func dateFormatter(rowDate: String, date: Bool) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy"
        
        let timeFormatterPrint = DateFormatter()
        timeFormatterPrint.dateFormat = "HH:mm:ss"
        
        var formatedDate = ""
        
        if date {
            if let date = dateFormatterGet.date(from: rowDate) {
                formatedDate = dateFormatterPrint.string(from: date)
                
            } else {
                print("There was an error decoding the string")
            }
        }
        else{
            if let Time = dateFormatterGet.date(from: rowDate){
                formatedDate = timeFormatterPrint.string(from: Time)
            }
            else {
                print("There was an error decoding the string")
            }
        }
        return formatedDate
    }
    
    func reOrderServiceApi(index: Int){
        
        if isRental {
            let rentalService = rentalDataSource[index]
            let navigationController = UINavigationController()
            navigationController.setupAppThemeNavigationBar()
            let selectServicesViewController = SelectServicesViewController()
            selectServicesViewController.addCustomBackButton()
            selectServicesViewController.isHisoryService = true
            selectServicesViewController.selectedCityFromHistory = rentalService.cityId
            let serviceObj = Mapper<ServiceModel>().map(JSON: [:])!
            serviceObj.id = rentalService.id
            serviceObj.equpmentName = rentalService.equipmentName
            selectServicesViewController.isRental = true
            selectServicesViewController.selectedServiceObj = serviceObj
            selectServicesViewController.serviceComments = rentalService.comment
            navigationController.viewControllers = [selectServicesViewController]
            self.present(navigationController, animated: true, completion: nil)
        }
        else{
            let services = serviceDataSource[index]
            let navigationController = UINavigationController()
            navigationController.setupAppThemeNavigationBar()
            let selectServicesViewController = SelectServicesViewController()
            selectServicesViewController.addCustomBackButton()
            selectServicesViewController.isHisoryService = true
            selectServicesViewController.selectedCityFromHistory = services.cityId
            selectServicesViewController.selectedServiceObj = services.service
            selectServicesViewController.serviceComments = services.comments
            selectServicesViewController.cityId = services.cityId
            navigationController.viewControllers = [selectServicesViewController]
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}

//MARK: - UITableView Delegate & DataSource

extension MyOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isService{
            return serviceDataSource.count
        
        } else if isRental {
            return rentalDataSource.count
        
        } else {
            return dataSource.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OrderTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        
        cell.statusOuterView.clipsToBounds = true
        cell.statusOuterView.layer.cornerRadius = 7
        cell.statusOuterView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        cell.statusInnerView.clipsToBounds = true
        cell.statusInnerView.layer.cornerRadius = 7
        cell.statusInnerView.layer.maskedCorners = [ .layerMinXMinYCorner]
        
        if isService {
            cell.dateLabel.text = self.dateFormatter(rowDate: serviceDataSource[indexPath.row].createdAt, date: true)
            cell.timeLabel.text = self.dateFormatter(rowDate: serviceDataSource[indexPath.row].createdAt, date: false)
            cell.orderIdLabel.text = serviceDataSource[indexPath.row].orderNumber
            cell.orderAmountLabel.text = "\(serviceDataSource[indexPath.row].totalAmount)"
            if (serviceDataSource[indexPath.row].paymentMethod == 4) {
                cell.paymentTypeLabel.text = "Cash on delivery"
            
            }
            else if (serviceDataSource[indexPath.row].paymentMethod == 5){
                cell.paymentTypeLabel.text = "EasyPaisa"
            }
            else {
                cell.paymentTypeLabel.text = "JazzCash"
            }
            cell.setOrderStautus(status: serviceDataSource[indexPath.row].orderStatus)
            cell.delegate = self
            
        } else if isRental {
            cell.dateLabel.text = self.dateFormatter(rowDate: rentalDataSource[indexPath.row].createdAt, date: true)
            cell.timeLabel.text = self.dateFormatter(rowDate: rentalDataSource[indexPath.row].createdAt, date: false)
            cell.orderIdLabel.text = rentalDataSource[indexPath.row].orderNumber
            cell.orderAmountLabel.text = "\(rentalDataSource[indexPath.row].price)"
            if (rentalDataSource[indexPath.row].paymentMethodId == 4) {
                cell.paymentTypeLabel.text = "Cash on delivery"
                
            }
            else if (rentalDataSource[indexPath.row].paymentMethodId == 5){
                cell.paymentTypeLabel.text = "EasyPaisa"
            }
            else {
                cell.paymentTypeLabel.text = "JazzCash"
            }
            cell.setOrderStautus(status: rentalDataSource[indexPath.row].status)
            cell.delegate = self
        
        } else {
            cell.dateLabel.text = self.dateFormatter(rowDate: dataSource[indexPath.row].createdAt, date: true)
            cell.timeLabel.text = self.dateFormatter(rowDate: dataSource[indexPath.row].createdAt, date: false)
            cell.orderIdLabel.text = dataSource[indexPath.row].orderNumber
            cell.orderAmountLabel.text = "\(dataSource[indexPath.row].totalAmount)"
            if (dataSource[indexPath.row].paymentMethod == 4){
                cell.paymentTypeLabel.text = "Cash on delivery"
                
            }
            else if (dataSource[indexPath.row].paymentMethod == 5){
                cell.paymentTypeLabel.text = "EasyPaisa"
            }
            else {
                cell.paymentTypeLabel.text = "JazzCash"
            }
            cell.setOrderStautus(status: dataSource[indexPath.row].orderStatus)
            cell.delegate = self
        }
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging 1")
        print("scrollViewDidEndDragging 2")
        if ((self.myOrdersTableView.contentOffset.y + self.myOrdersTableView.frame.size.height) >= self.myOrdersTableView.contentSize.height)
        {
            if !self.isDataLoading{
                self.isDataLoading = true
                self.pageNo=self.pageNo+1
                
                
                if self.isService{
                    self.getServiceHistroyApiCall(pageNo: self.pageNo, limit: self.limit)
                    
                } else if self.isRental {
                    self.getRentalServices(pageNo: self.pageNo, limit: self.limit)
                    
                } else {
                    self.getOrderHistroyApiCall(pageNo: self.pageNo, limit: self.limit)
                }
            }
        }
    }
}


extension MyOrdersViewController :  OrderTableViewCellDelegate {
    func reOrder(cell: OrderTableViewCell) {
        if let indexPath = myOrdersTableView.indexPath(for: cell) {
            
            if isService || isRental {
                self.reOrderServiceApi(index: indexPath.row)
            
            } else {
                for order in self.dataSource[indexPath.row].orderDetails {
                    print("your order",order.productId)
                    var itemName = ""
                    var price = 0.0
                    var isPrescp = 0
                    var itemType : ProductType = .Medicine
                    if order.productType == ProductType.Medicine.rawValue {
                        itemName = order.medicineDetails.medicineName
                        price = order.medicineDetails.price
                        itemType = .Medicine
                        isPrescp = order.medicineDetails.isPrescriptionRequired
                    }
                    if order.productType == ProductType.Equipment.rawValue {
                        itemName = order.equipmentDetails.equipmentName
                        price = order.equipmentDetails.price
                        itemType = .Equipment
                    }
                    if order.productType == ProductType.Test.rawValue {
                        itemName = order.testDetails.testName
                        price = order.testDetails.price
                        itemType = .Test
                        isPrescp = order.testDetails.isPrescriptionReq
                    }
                    if order.productType == ProductType.Miscellenaous.rawValue {
                        itemName = order.otherMedicineDetails.medicineName
                        price = order.otherMedicineDetails.price
                        itemType = .Miscellenaous
                        isPrescp = order.otherMedicineDetails.isPrescriptionRequired
                        
                    }
                    
                    Utility.addUpdateInCart(productId: order.productId, quantity: order.quantity, productType: itemType, title: itemName,price: price, description: "" , isPrep: isPrescp)
//                    if Utility.getCartItems().count > 0 {
                        let navigationController = UINavigationController()
                        navigationController.setupAppThemeNavigationBar()
                        let confirmViewController = ConfirmSelectionViewController()
                        confirmViewController.isHome = true
                        navigationController.viewControllers = [confirmViewController]
                        self.present(navigationController, animated: true, completion: nil)
//                    }
                }
            }
        }
    }
}

