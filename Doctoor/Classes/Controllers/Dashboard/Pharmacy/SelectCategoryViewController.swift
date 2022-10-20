//
//  SelectCategoryViewController.swift
//  Doctoor
//
//  Created by DevBatch on 24/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class SelectCategoryViewController: UIViewController {
    
    //MARK: - Variables
    
    let navImages: [UIImage] = [#imageLiteral(resourceName: "upload-prescription") , #imageLiteral(resourceName: "miscellaneous")]
    
    let navString: [String] = [
        "Upload",
        "Other Categories"
    ]
    
    var dataSource = [MedicineCategory]()
    
    var isLoadData = false
    
    //MARK: - Outlets
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var searchView: HMView!
    
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let filterBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        filterBtn.setImage(#imageLiteral(resourceName: "cart"), for: .normal)
        filterBtn.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        filterBtn.addBadge(number: Utility.getCartItems().count)
        let barButton = UIBarButtonItem(customView: filterBtn)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "Select ", secondTitle: "Category")
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))        
        let search = UITapGestureRecognizer(target: self, action: #selector(searchTapped(sender:)))
        searchView.addGestureRecognizer(search)
        getMedicineCategoryApi()
        
    }
    
    //MARK: - Private Methods
    
    @objc func searchTapped(sender: UITapGestureRecognizer){
        let selectCategorySearchViewController = SelectCategorySearchViewController()
        selectCategorySearchViewController.isOutterSearch = true
        selectCategorySearchViewController.addCustomBackButton()
        self.navigationController?.pushViewController(selectCategorySearchViewController, animated: true)
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addTapped(sender: UIBarButtonItem) {
        //        self.dismiss(animated: true, completion: nil)
        
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
    
    
    func getMedicineCategoryApi() {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getMedicineCategory(page: -1, limit: 50) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.isLoadData = true
                if let data = Mapper<MedicineCategory>().mapArray(JSONObject: result) {
                    self.dataSource = data
                    self.categoryCollectionView.reloadData()
                }
            }
        }
    }
}

extension SelectCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoadData && dataSource.count > 0 {
            return dataSource.count + 2
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 || indexPath.item == (dataSource.count + 1) {
            let rectCell = FullRectCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
            rectCell.upperTitleLabel.isHidden = false
            rectCell.lowerTitleLabel.isHidden = false
            rectCell.thirdLabel.isHidden = true
            
            if indexPath.item == (dataSource.count + 1) {
                rectCell.placeImageView.image = navImages[1]
                rectCell.upperTitleLabel.isHidden = true
                rectCell.lowerTitleLabel.isHidden = true
                rectCell.thirdLabel.isHidden = false
                
            } else {
                rectCell.placeImageView.image = navImages[0]
            }
            return rectCell
        }
        
        let sqaureCell = SquareCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
        if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(dataSource[indexPath.item - 1].image)") {
            sqaureCell.catImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
            })
            print("url->",url)
        }
        sqaureCell.catLabel.text = dataSource[indexPath.item - 1].categoryName
        return sqaureCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 0 || indexPath.item == (dataSource.count + 1) {
            return CGSize(width: collectionView.frame.width, height: 90)
        }
        
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            
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
            
            
            
        } else {
            let medicineViewController = FaminineViewController()
            medicineViewController.addCustomBackButton()
            if indexPath.item > 0 && indexPath.item < (dataSource.count + 1) {
                medicineViewController.id = dataSource[indexPath.item - 1].id
            }
            if indexPath.item == (dataSource.count + 1) {
                medicineViewController.isMisMedicine = true
            }
            self.navigationController?.pushViewController(medicineViewController, animated: true)
        }
    }
}
