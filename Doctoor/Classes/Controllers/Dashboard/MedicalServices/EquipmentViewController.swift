//
//  EquipmentViewController.swift
//  Doctoor
//
//  Created by DevBatch on 24/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper


class EquipmentViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var searchView: HMView!
    
    
    //MARK: - Variables
    
    var dataSource = [MedicalEquip]()
    
    var cartItems = [CartOrder]()
    
    var selectedCity = Mapper<CityModel>().map(JSON: [:])!
    
    var filterButton = UIButton()
    
    var isDataLoading:Bool=false
    
    var pageNo:Int=1
    
    var limit:Int=20
    
    var offset:Int=0 //pageNo*limit

    
    //MARK: - Outlets
    
    @IBOutlet weak var equipmentCollectionView: UICollectionView!
    
    //MARK: - UIViewController Methods
    
    override func viewWillAppear(_ animated: Bool) {
        filterButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        filterButton.setImage(#imageLiteral(resourceName: "cart"), for: .normal)
        filterButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        filterButton.addBadge(number: Utility.getCartItems().count)
        let barButton = UIBarButtonItem(customView: filterButton)
        self.navigationItem.rightBarButtonItem = barButton
        dataSource.removeAll()
        pageNo = 1
        doGetMedicalEquipment(pageNo: pageNo, limit: limit)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        equipmentCollectionView.delegate = self
        equipmentCollectionView.dataSource = self
        
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "Select ", secondTitle: "Equipment")
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        
        let search = UITapGestureRecognizer(target: self, action: #selector(searchTapped(sender:)))
        searchView.addGestureRecognizer(search)
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        
    }
    
    @objc func searchTapped(sender: UITapGestureRecognizer){
        let selectCategorySearchViewController = SelectCategorySearchViewController()
        selectCategorySearchViewController.addCustomBackButton()
        selectCategorySearchViewController.isEquipment = true
        selectCategorySearchViewController.cityId = self.selectedCity.id
        self.navigationController?.pushViewController(selectCategorySearchViewController, animated: true)
        
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
    
    @IBAction func fabButtonTapped(_ sender: Any) {
        Utility.dialNumber()
    }
    
    
    //MARK: - private Methods
    
    func doGetMedicalEquipment(pageNo: Int, limit: Int){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getMedicalEquipments(pageNo: pageNo, limit: limit) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: true)
            }
            else {
                if let data = Mapper<MedicalEquip>().mapArray(JSONObject: result) {
                    
                    self.dataSource.append(contentsOf: data)
                    self.equipmentCollectionView.reloadData()
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
    
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension EquipmentViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = EquipmentCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
        cell.delegate = self
        if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(self.dataSource[indexPath.item].image)") {
            cell.equipImage.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
            })
            if dataSource[indexPath.row].isCart {
                cell.cartImageView.image = #imageLiteral(resourceName: "select-cart")
                
            } else {
                cell.cartImageView.image = #imageLiteral(resourceName: "unselect-cart")
            }
            print("URL",url)
        }
        cell.isCartSelected =  dataSource[indexPath.row].isCart
        cell.name.text = self.dataSource[indexPath.row].equipName
        cell.price.text = "\(self.dataSource[indexPath.row].price)"
        cell.brandName.text = self.dataSource[indexPath.row].brand
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let equipmentDetailsViewController = EquipmentDetailsViewController()
        equipmentDetailsViewController.addCustomBackButton()
        let selectedRow = self.dataSource[indexPath.row]
        equipmentDetailsViewController.selectedEquipment = selectedRow
        self.navigationController?.pushViewController(equipmentDetailsViewController, animated: true)
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
        
        if ((equipmentCollectionView.contentOffset.y + equipmentCollectionView.frame.size.height) >= equipmentCollectionView.contentSize.height)
        {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo=self.pageNo+1
                //                self.limit=10
                
                doGetMedicalEquipment(pageNo: self.pageNo, limit: self.limit)
            }
        }
    }
}
extension EquipmentViewController : EquipmentCollectionViewCellDelegate{
    func didCartItemTapped(cell: EquipmentCollectionViewCell, isAdd: Bool) {
        if let indexPath = equipmentCollectionView.indexPath(for: cell){
        
            
            if isAdd {
                Utility.addUpdateInCart(productId: dataSource[indexPath.row].id, quantity: 1, productType: .Equipment, title: dataSource[indexPath.row].equipName, price: dataSource[indexPath.row].price, description: dataSource[indexPath.row].description)
            }
            else {
                Utility.removeInCart(productId: dataSource[indexPath.row].id, productType: .Equipment)
            }
        filterButton.addBadge(number: Utility.getCartItems().count)

        }
    }
    
    func didFinishTask(cell: EquipmentCollectionViewCell) {
        
    }
}

