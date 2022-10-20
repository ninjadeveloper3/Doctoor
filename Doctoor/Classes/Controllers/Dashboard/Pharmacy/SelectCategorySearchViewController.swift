//
//  SelectCategorySearchViewController.swift
//  Doctoor
//
//  Created by DevBatch on 23/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper
import IQKeyboardManagerSwift

class SelectCategorySearchViewController: UIViewController {
    
    //MARK: - Variables
    
    var dataSource = Mapper<SearchMedicine>().map(JSON: [:])!
    
    var medicineDatasource = [MedicineItem]()
    
    var equipmentDataSource = [MedicalEquip]()
    
    var isLoadData = false
    
    var id = 0
    
    var isEquipment = false
    
    var cityId = 0
    
    var cartItems = [CartOrder]()
    
    var isOutterSearch = false
    
    var filterButton = UIButton()
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var categorySearchCollectionView: UICollectionView!
    
    @IBOutlet weak var searchInput: UITextField!
    
    @IBOutlet weak var searchIcon: UIImageView!
    
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        searchInput.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        searchInput.becomeFirstResponder()
    }
    
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        let navLabel = UILabel()
        if (isEquipment){
            let navTitle = Utility.attributedTitle(firstTitle: "Search ", secondTitle: "Equipment")
            navLabel.attributedText = navTitle
        }
        else{
            let navTitle = Utility.attributedTitle(firstTitle: "Select ", secondTitle: "Medicines")
            navLabel.attributedText = navTitle
        }
        
        navigationItem.titleView = navLabel
        
        filterButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        filterButton.setImage(#imageLiteral(resourceName: "cart"), for: .normal)
        filterButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        filterButton.addBadge(number: Utility.getCartItems().count)
        let barButton = UIBarButtonItem(customView: filterButton)
        self.navigationItem.rightBarButtonItem = barButton
        
        let search = UITapGestureRecognizer(target: self, action: #selector(searchIconTapped(sender:)))
        searchIcon.addGestureRecognizer(search)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            self.searchInput.becomeFirstResponder()
        }
    }
    
    //MARK: - IBActions Methods
    
    @objc func addTapped(sender: UIBarButtonItem){
//        if Utility.getCartItems().count > 0 {
            let navigationController = UINavigationController()
            navigationController.setupAppThemeNavigationBar()
            let confirmViewController = ConfirmSelectionViewController()
            confirmViewController.isHome = true
            navigationController.viewControllers = [confirmViewController]
            self.present(navigationController, animated: true, completion: nil)
//        }
    }
    
        
    @IBAction func searchInputChanged(_ sender: UITextField) {
        if sender.text!.count > 0 {
            self.searchIcon.image = #imageLiteral(resourceName: "close")
            self.searchIcon.bounds.size = CGSize(width: 15, height: 15)
        }
        if sender.text!.isEmpty{
            if isOutterSearch {
                getMedicineList(TxtSearch: "a")
                
            } else {
                if(isEquipment){
                    getEquipmentList()
                }
                else{
                    getMedicineList()
                }
            }
        }
        else{
            let txt = sender.text!.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            if isOutterSearch {
                getMedicineList(TxtSearch: txt)
                
            } else {
                if(isEquipment){
                    getEquipmentList(TxtSearch: txt)
                }
                else{
                    getMedicineList(TxtSearch: txt)
                }
                
            }
        }
    }
    
    
    //MARK: - Private Methods
    
    func getMedicineList(TxtSearch: String) {
        print("Cat ID: \(id)")
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.searchFromPharmacy(searchItem: TxtSearch) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.isLoadData = true
                if let data = Mapper<SearchMedicine>().map(JSONObject: result) {
                    self.dataSource = data
                    
                } else {
                    self.dataSource.medicines.removeAll()
                    self.dataSource.miscellaneous.removeAll()
                }
                self.categorySearchCollectionView.reloadData()
                self.cartItems = Utility.getCartItems()
                for data in self.dataSource.medicines {
                    for (index, _) in self.cartItems.enumerated() {
                        if data.id == self.cartItems[index].productId {
                            data.isCart = true
                        }
                    }
                }
                for data in self.dataSource.miscellaneous {
                    for (index, _) in self.cartItems.enumerated() {
                        if data.id == self.cartItems[index].productId {
                            data.isCart = true
                        }
                    }
                }
            }
        }
    }
    
    func getMedicineList() {
        print("Cat ID: \(id)")
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getMedicineList(categoryId: id, page: 0, limit: 20) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.isLoadData = true
                if let data = Mapper<MedicineItem>().mapArray(JSONObject: result) {
                    self.medicineDatasource = data
                    self.categorySearchCollectionView.reloadData()
                }
            }
        }
    }
    
    func getEquipmentList(){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getMedicalEquipments(pageNo: 1, limit: 20) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: true)
            }
            else {
                if let data = Mapper<MedicalEquip>().mapArray(JSONObject: result) {
                    self.equipmentDataSource = data
                    
                } else {
                    self.equipmentDataSource.removeAll()
                }
                self.categorySearchCollectionView.reloadData()
                self.cartItems = Utility.getCartItems()
                for data in self.equipmentDataSource {
                    for (index, _) in self.cartItems.enumerated() {
                        if data.id == self.cartItems[index].productId {
                            data.isCart = true
                        }
                    }
                }
            }
        }
    }
    
    func getEquipmentList(TxtSearch: String) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.searchEquipmentList(searchItem: TxtSearch,cityId: cityId, page: 1, limit: 20) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.isLoadData = true
                if let data = Mapper<MedicalEquip>().mapArray(JSONObject: result) {
                    self.equipmentDataSource = data
                    
                } else {
                    self.equipmentDataSource.removeAll()
                }
                self.categorySearchCollectionView.reloadData()
                self.cartItems = Utility.getCartItems()
                for data in self.equipmentDataSource {
                    for (index, _) in self.cartItems.enumerated() {
                        if data.id == self.cartItems[index].productId {
                            data.isCart = true
                        }
                    }
                }
            }
        }
    }
    
    @objc func searchIconTapped(sender: UITapGestureRecognizer){
        searchInput.text = ""
        self.searchIcon.image = #imageLiteral(resourceName: "search")
        self.searchIcon.bounds.size = CGSize(width: 30, height: 30)
        if isOutterSearch {
            getMedicineList(TxtSearch: "a")
            
        } else {
            if (isEquipment) {
                getEquipmentList()
                
            } else {
                getMedicineList()
            }
        }
    }
}
extension SelectCategorySearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isOutterSearch {
            if isLoadData {
                return dataSource.medicines.count + dataSource.miscellaneous.count
            }
            return 0
            
        } else {
            if isLoadData && medicineDatasource.count > 0 {
                return medicineDatasource.count
            }
            if isLoadData && equipmentDataSource.count > 0 {
                return equipmentDataSource.count
            }
            return 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isOutterSearch {
            let cell = FaminineCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
            cell.delegate = self
            if indexPath.row < dataSource.medicines.count {
                cell.medicineTitle.text = dataSource.medicines[indexPath.item].medicineName
                cell.priceLabel.text = "\(dataSource.medicines[indexPath.item].price)"
                if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(dataSource.medicines[indexPath.item].medicineImage)") {
                    cell.medicineImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                    })
                }
                if dataSource.medicines[indexPath.item].unit != "" {
                    cell.unitLabel.isHidden = false
                cell.unitLabel.text = "(\(dataSource.medicines[indexPath.item].unit.lowercased()))"
                }
                else{
                    cell.unitLabel.isHidden = true
                }
                if dataSource.medicines[indexPath.item].isCart {
                    cell.cartImageView.image = #imageLiteral(resourceName: "select-cart")
                    
                } else {
                    cell.cartImageView.image = #imageLiteral(resourceName: "unselect-cart")
                }
                cell.isCartSelected =  dataSource.medicines[indexPath.item].isCart
                
            } else {
                let index = indexPath.item - self.dataSource.medicines.count
                cell.medicineTitle.text = dataSource.miscellaneous[index].medicineName
                cell.priceLabel.text = "\(dataSource.miscellaneous[index].price)"
                
                if dataSource.miscellaneous[index].medicineImage != "" {
                    if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(dataSource.miscellaneous[index].medicineImage)") {
                        cell.medicineImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                        })
                    }
                }
                else{
                    cell.medicineImageView.image = #imageLiteral(resourceName: "online-Pharmacy")
                }
                
                if dataSource.miscellaneous[index].unit != "" {
                    cell.unitLabel.isHidden = false
                cell.unitLabel.text = "(\(dataSource.miscellaneous[index].unit.lowercased()))"
                }
                else{
                    cell.unitLabel.isHidden = true
                }
                if dataSource.miscellaneous[index].isCart {
                    cell.cartImageView.image = #imageLiteral(resourceName: "select-cart")
                    
                } else {
                    cell.cartImageView.image = #imageLiteral(resourceName: "unselect-cart")
                }
                cell.isCartSelected =  dataSource.miscellaneous[index].isCart
                
            }
            return cell
        }
        
        if isEquipment{
            let cell = EquipmentCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
            cell.delegate = self
            if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(self.equipmentDataSource[indexPath.item].image)") {
                cell.equipImage.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                })
                if equipmentDataSource[indexPath.row].isCart {
                    cell.cartImageView.image = #imageLiteral(resourceName: "select-cart")
                    
                } else {
                    cell.cartImageView.image = #imageLiteral(resourceName: "unselect-cart")
                }
                print("URL",url)
            }
            cell.isCartSelected =  equipmentDataSource[indexPath.row].isCart
            cell.name.text = self.equipmentDataSource[indexPath.row].equipName
            cell.price.text = "\(self.equipmentDataSource[indexPath.row].price)"
            cell.brandName.text = self.equipmentDataSource[indexPath.row].brand
            if equipmentDataSource[indexPath.row].isCart {
                cell.cartImageView.image = #imageLiteral(resourceName: "select-cart")
                
            } else {
                cell.cartImageView.image = #imageLiteral(resourceName: "unselect-cart")
            }
            return cell
            
        } else {
            let cell = FaminineCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
            
            cell.medicineTitle.text = medicineDatasource[indexPath.item].medicineName
            cell.priceLabel.text = "\(medicineDatasource[indexPath.item].price)"
            cell.delegate = self
            if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(medicineDatasource[indexPath.item].medicineImage)") {
                cell.medicineImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                })
            }
            if medicineDatasource[indexPath.item].unit != "" {
                cell.unitLabel.isHidden = false
            cell.unitLabel.text = "(\(medicineDatasource[indexPath.item].unit.lowercased()))"
            }
            else{
                cell.unitLabel.isHidden = true
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: 203)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isOutterSearch {
            if indexPath.row < self.dataSource.medicines.count {
                let medicineDetailViewController = MedicalDetailsViewController()
                medicineDetailViewController.dataSource = dataSource.medicines[indexPath.item]
                self.navigationController?.pushViewController(medicineDetailViewController, animated: true)
                
            } else {
                let medicineDetailViewController = MedicalDetailsViewController()
                let index = indexPath.item - self.dataSource.medicines.count
                medicineDetailViewController.dataSource = dataSource.miscellaneous[index]
                self.navigationController?.pushViewController(medicineDetailViewController, animated: true)
            }
            
        } else if isEquipment {
            let equipmentDetailsViewController = EquipmentDetailsViewController()
            equipmentDetailsViewController.addCustomBackButton()
            
            equipmentDetailsViewController.selectedEquipment = self.equipmentDataSource[indexPath.item]
            self.navigationController?.pushViewController(equipmentDetailsViewController, animated: true)
            
        } else {
            let medicineDetailViewController = MedicalDetailsViewController()
            medicineDetailViewController.dataSource = medicineDatasource[indexPath.item]
            self.navigationController?.pushViewController(medicineDetailViewController, animated: true)
        }
    }
}
extension SelectCategorySearchViewController: FaminineCollectionViewCellDelegate,EquipmentCollectionViewCellDelegate {
    func didFinishTask(cell: EquipmentCollectionViewCell) {
        print("task")
    }
    
    func didCartItemTapped(cell: EquipmentCollectionViewCell, isAdd: Bool) {
        if let indexPath = categorySearchCollectionView.indexPath(for: cell){
            if isAdd {
                Utility.addUpdateInCart(productId: equipmentDataSource[indexPath.row].id, quantity: 1, productType: .Equipment, title: equipmentDataSource[indexPath.row].equipName, price: equipmentDataSource[indexPath.row].price, description: equipmentDataSource[indexPath.row].description)
            }
            else {
                Utility.removeInCart(productId: equipmentDataSource[indexPath.row].id, productType: .Equipment)
            }
            filterButton.addBadge(number: Utility.getCartItems().count)
        }
    }
    
    func didCartItemTapped(cell: FaminineCollectionViewCell, isAdd: Bool) {
        if let indexPath = categorySearchCollectionView.indexPath(for: cell){
            if isAdd {
                if isOutterSearch {
                    if indexPath.row < self.dataSource.medicines.count {
                        Utility.addUpdateInCart(productId: dataSource.medicines[indexPath.row].id, quantity: 1, productType: .Medicine, title: dataSource.medicines[indexPath.row].medicineName, price: dataSource.medicines[indexPath.row].price)
                        
                    } else {
                        
                        let index = indexPath.item - self.dataSource.medicines.count
                        
                        Utility.addUpdateInCart(productId: dataSource.miscellaneous[index].id, quantity: 1, productType: .Medicine, title: dataSource.miscellaneous[index].medicineName, price: dataSource.miscellaneous[index].price,description: "",isPrep: dataSource.miscellaneous[index].isPrescriptionRequired)
                        
                    }
                    
                } else {
                    Utility.addUpdateInCart(productId: medicineDatasource[indexPath.row].id, quantity: 1, productType: .Medicine, title: medicineDatasource[indexPath.row].medicineName, price: medicineDatasource[indexPath.row].price,description: "",isPrep: medicineDatasource[indexPath.row].isPrescriptionRequired)
                }
                
            } else {
                if isOutterSearch {
                    if indexPath.row < self.dataSource.medicines.count {
                        
                        Utility.removeInCart(productId: dataSource.medicines[indexPath.row].id, productType: .Medicine)
                    } else {
                        
                        let index = indexPath.item - self.dataSource.medicines.count
                        
                        Utility.removeInCart(productId: dataSource.miscellaneous[index].id, productType: .Medicine)
                    }
                    
                } else {                    
                    Utility.removeInCart(productId: medicineDatasource[indexPath.row].id, productType: .Medicine)
                }
            }
            filterButton.addBadge(number: Utility.getCartItems().count)
        }
    }
}

//extension SelectCategorySearchViewController : EquipmentCollectionViewCellDelegate{
//    func didCartItemTapped(cell: EquipmentCollectionViewCell, isAdd: Bool) {
//        if let indexPath = categorySearchCollectionView.indexPath(for: cell){
//
//
//            if isAdd {
////                Utility.addUpdateInCart(productId: dataSource[indexPath.row].id, quantity: 1, productType: .Equipment, title: dataSource[indexPath.row].equipName, price: dataSource[indexPath.row].price, description: dataSource[indexPath.row].description)
//            }
//            else {
////                Utility.removeInCart(productId: dataSource[indexPath.row].id, productType: .Equipment)
//            }
//            filterButton.addBadge(number: Utility.getCartItems().count)
//
//        }
//    }
//
//    func didFinishTask(cell: EquipmentCollectionViewCell) {
//
//    }
//}
//
