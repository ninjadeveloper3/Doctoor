//
//  categorySearchByIdViewController.swift
//  Doctoor
//
//  Created by DevBatch on 28/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper
import IQKeyboardManagerSwift


class CategorySearchByIdViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Variables
    
    var dataSource = [MedicineItem]()
    
    var isLoadData = false
    
    var id = 0
    
    var filterButton = UIButton()
    
    var cartItems = [CartOrder]()
    
    var isMisMedicine = false
    
    //MARK: - Outlets
    
    @IBOutlet weak var searchResultMedicine: UICollectionView!
    
    @IBOutlet weak var searchIcon: UIImageView!
    
    @IBOutlet weak var searchInput: UITextField!
    
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        searchInput.becomeFirstResponder()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "Select ", secondTitle: "Medicines")
        navLabel.attributedText = navTitle
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
            if id != 0 {
                getMedicineList()
            }
            else{
                searchMedicine(searchText: "a")
            }
            
        } else {
            let txt = sender.text!.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            if isMisMedicine {
                searchMedicine(searchText: txt)
            
            } else {
                getMedicineListById(TxtSearch: txt)
            }
        }

    }
    
    @objc func searchIconTapped(sender: UITapGestureRecognizer){
        searchInput.text = ""
        self.searchIcon.image = #imageLiteral(resourceName: "search")
        self.searchIcon.bounds.size = CGSize(width: 30, height: 30)
        if id != 0 {
            getMedicineList()
        }
        else{
            searchMedicine(searchText: "a")
        }
    }
    
    //MARK: - Private Methods
    
    func getMedicineListById(TxtSearch: String) {
        print("Cat ID: \(id)")
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.searchMedicineById(searchItem: TxtSearch, categoryId: id) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.dataSource.removeAll()
                self.isLoadData = true
                if let data = Mapper<MedicineItem>().mapArray(JSONObject: result) {
                    self.dataSource = data
                    self.searchResultMedicine.reloadData()
                    self.cartItems = Utility.getCartItems()
                    for data in self.dataSource {
                        for (index, _) in self.cartItems.enumerated() {
                            if data.id == self.cartItems[index].productId {
                                data.isCart = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    func searchMedicine(searchText: String) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getSearchOtherMedicine(medicineName: searchText) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                 error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.dataSource.removeAll()
                self.isLoadData = true
                if let data = Mapper<MedicineItem>().mapArray(JSONObject: result) {
                    self.dataSource = data
                    self.searchResultMedicine.reloadData()
                }
            }
        }
    }

    func getMedicineList() {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getMedicineList(categoryId: id, page: 0, limit: 20) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.dataSource.removeAll()
                self.isLoadData = true
                if let data = Mapper<MedicineItem>().mapArray(JSONObject: result) {
                    self.dataSource = data
                    self.searchResultMedicine.reloadData()
                    self.cartItems = Utility.getCartItems()
                    for data in self.dataSource {
                        for (index, _) in self.cartItems.enumerated() {
                            if data.id == self.cartItems[index].productId {
                                data.isCart = true
                            }
                        }
                    }
                }
            }
        }
    }
}

extension CategorySearchByIdViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoadData && dataSource.count > 0 {
            return dataSource.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = FaminineCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
        cell.medicineTitle.text = dataSource[indexPath.item].medicineName
        cell.priceLabel.text = "\(dataSource[indexPath.item].price)"
        cell.isCartSelected =  dataSource[indexPath.row].isCart
        cell.delegate = self
        if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(dataSource[indexPath.item].medicineImage)") {
            cell.medicineImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
            })
        }
        if dataSource[indexPath.item].unit != "" {
            cell.unitLabel.isHidden = false
            cell.unitLabel.text = "(\(dataSource[indexPath.item].unit.lowercased()))"
        }
        else{
            cell.unitLabel.isHidden = true
        }
        if dataSource[indexPath.row].isCart {
            cell.cartImageView.image = #imageLiteral(resourceName: "select-cart")
            
        } else {
            cell.cartImageView.image = #imageLiteral(resourceName: "unselect-cart")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: 203)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let medicineDetailViewController = MedicalDetailsViewController()
        if isMisMedicine {
        medicineDetailViewController.isMisMedicine = true
        }
        medicineDetailViewController.dataSource = dataSource[indexPath.item]
        self.navigationController?.pushViewController(medicineDetailViewController, animated: true)
    }
}

extension CategorySearchByIdViewController: FaminineCollectionViewCellDelegate {
    func didCartItemTapped(cell: FaminineCollectionViewCell, isAdd: Bool) {
        if let indexPath = searchResultMedicine.indexPath(for: cell){
            if isAdd {
                if isMisMedicine {
                    Utility.addUpdateInCart(productId: dataSource[indexPath.row].id, quantity: 1, productType: .Miscellenaous, title: dataSource[indexPath.row].medicineName, price: dataSource[indexPath.row].price,isPrep: dataSource[indexPath.row].isPrescriptionRequired)
                }
                else{
                    Utility.addUpdateInCart(productId: dataSource[indexPath.row].id, quantity: 1, productType: .Medicine, title: dataSource[indexPath.row].medicineName, price: dataSource[indexPath.row].price)
                }
            }
            else {
                if (isMisMedicine) {
                    Utility.removeInCart(productId: dataSource[indexPath.row].id, productType: .Miscellenaous)
                }
                else{
                    Utility.removeInCart(productId: dataSource[indexPath.row].id, productType: .Medicine)
                }
            }
            filterButton.addBadge(number: Utility.getCartItems().count)
        }
    }
}

