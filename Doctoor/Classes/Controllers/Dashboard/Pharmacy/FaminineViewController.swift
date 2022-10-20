//
//  FaminineViewController.swift
//  Doctoor
//
//  Created by Zeeshan Haider on 24/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class FaminineViewController: UIViewController {
    
    //MARK: - Variables
    
    var dataSource = [MedicineItem]()
    
    var isLoadData = false
    
    var id = 0
    
    var cartItems = [CartOrder]()
    
    var isDataLoading : Bool = false
    
    var pageNo : Int = 1
    
    var limit : Int = 20
    
    var offset : Int = 0 //pageNo*limit
    
    var filterButton = UIButton()
    
    var isMisMedicine = false
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    @IBOutlet weak var searchView: HMView!
    
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        filterButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        filterButton.setImage(#imageLiteral(resourceName: "cart"), for: .normal)
        filterButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        filterButton.addBadge(number: Utility.getCartItems().count)
        let barButton = UIBarButtonItem(customView: filterButton)
        self.navigationItem.rightBarButtonItem = barButton
        dataSource.removeAll()
        pageNo = 1
        if isMisMedicine {
            getOtherMedicine(pageNo: pageNo, limit: limit)
            
        } else {
            getMedicineList(pageNo: pageNo, limit: limit)
        }
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "Select ", secondTitle: "Medicines")
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
        let search = UITapGestureRecognizer(target: self, action: #selector(searchTapped(sender:)))
        searchView.addGestureRecognizer(search)
    }
    
    //MARK: - IBActions Methods
    
    
    
    //MARK: - Private Methods
    
    @objc func searchTapped(sender: UITapGestureRecognizer){
        let categorySearchById = CategorySearchByIdViewController()
        if isMisMedicine {
            categorySearchById.isMisMedicine = isMisMedicine
            
        } else {
            categorySearchById.id = id
        }
        categorySearchById.addCustomBackButton()
        self.navigationController?.pushViewController(categorySearchById, animated: true)
    }
    
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
    
    @IBAction func fabButtonTapped(_ sender: Any) {
        Utility.dialNumber()
    }
    
    
    func getMedicineList(pageNo: Int, limit: Int) {
        print("Cat ID: \(id)")
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getMedicineList(categoryId: id, page: pageNo, limit: limit) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.isLoadData = true
                if let data = Mapper<MedicineItem>().mapArray(JSONObject: result) {
                    self.dataSource.append(contentsOf: data)
                    self.productsCollectionView.reloadData()
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
    
    func getOtherMedicine(pageNo: Int, limit: Int) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getOtherMedicines(page: pageNo, limit: limit) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.isLoadData = true
                if let data = Mapper<MedicineItem>().mapArray(JSONObject: result) {
                    self.dataSource.append(contentsOf: data)
                    self.productsCollectionView.reloadData()
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

extension FaminineViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoadData && dataSource.count > 0 {
            return dataSource.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = FaminineCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
        cell.delegate = self
        cell.medicineTitle.text = dataSource[indexPath.item].medicineName
        cell.priceLabel.text = "\(dataSource[indexPath.item].price)"
        cell.isCartSelected =  dataSource[indexPath.row].isCart
        if dataSource[indexPath.item].medicineImage.isEmpty {
            cell.medicineImageView.image = #imageLiteral(resourceName: "online-Pharmacy")
            
        } else {
            if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(dataSource[indexPath.item].medicineImage)") {
                cell.medicineImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                })
            }
        }
        if dataSource[indexPath.row].isCart {
            cell.cartImageView.image = #imageLiteral(resourceName: "select-cart")
            
        } else {
            cell.cartImageView.image = #imageLiteral(resourceName: "unselect-cart")
        }
        
        if dataSource[indexPath.item].unit != "" {
            cell.unitLabel.isHidden = false
            cell.unitLabel.text = "(\(dataSource[indexPath.item].unit.lowercased()))"
            
        } else {
            cell.unitLabel.isHidden = true
            cell.unitLabel.text = ""
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: 203)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let medicineDetailViewController = MedicalDetailsViewController()
        medicineDetailViewController.dataSource = dataSource[indexPath.row]
        medicineDetailViewController.isMisMedicine = self.isMisMedicine
        self.navigationController?.pushViewController(medicineDetailViewController, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        
        if ((productsCollectionView.contentOffset.y + productsCollectionView.frame.size.height) >= productsCollectionView.contentSize.height)
        {
            if !isDataLoading {
                isDataLoading = true
                self.pageNo = self.pageNo + 1
                if isMisMedicine {
                    getOtherMedicine(pageNo: pageNo, limit: limit)
                    
                } else {
                    getMedicineList(pageNo: pageNo, limit: limit)
                }
            }
        }
    }
}
extension FaminineViewController: FaminineCollectionViewCellDelegate {
    func didCartItemTapped(cell: FaminineCollectionViewCell, isAdd: Bool) {
        if let indexPath = productsCollectionView.indexPath(for: cell){
            
            if isAdd {
                if isMisMedicine {
                    Utility.addUpdateInCart(productId: dataSource[indexPath.row].id, quantity: 1, productType: .Miscellenaous, title: dataSource[indexPath.row].medicineName, price: dataSource[indexPath.row].price, description: "",isPrep: dataSource[indexPath.row].isPrescriptionRequired)

                } else {
                    Utility.addUpdateInCart(productId: dataSource[indexPath.row].id, quantity: 1, productType: .Medicine, title: dataSource[indexPath.row].medicineName, price: dataSource[indexPath.row].price, description: "",isPrep: dataSource[indexPath.row].isPrescriptionRequired)
                }
                
            } else {
                Utility.removeInCart(productId: dataSource[indexPath.row].id, productType: .Medicine)
            }
            filterButton.addBadge(number: Utility.getCartItems().count)
        }
    }
}
