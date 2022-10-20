//
//  TestCategoryViewController.swift
//  Doctoor
//
//  Created by DevBatch on 23/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class TestCategoryViewController: UIViewController {
    
    //MARK: - Variables
    
    var categoryDataSource = [LabCategory]()
    
    var isLoadData = false
    
    var isDataLoading : Bool = false
    
    var labId = 0
    
    var pageNo : Int = 1
    
    var limit : Int = 20
    
    var offset : Int = 0 //pageNo*limit
    
    //MARK: - Outlets
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var searchView: HMView!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("labId",labId)
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
    
    //MARK: - SetUp View Controller Methods
    
    func setUpViewController() {
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "Select ", secondTitle: "Category")
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        let search = UITapGestureRecognizer(target: self, action: #selector(searchTapped(sender:)))
        searchView.addGestureRecognizer(search)
        getCategories(pageNo: pageNo, limit: limit)
        
        let filterBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        filterBtn.setImage(#imageLiteral(resourceName: "cart"), for: .normal)
        filterBtn.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        filterBtn.addBadge(number: Utility.getCartItems().count)
        let barButton = UIBarButtonItem(customView: filterBtn)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    //MARK: - Private Methods
    
    @objc func addTapped(sender: UIBarButtonItem) {
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
    
    func getCategories(pageNo: Int,limit: Int) {
        
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getLabCategories(labId: labId, pageNo: pageNo, limit: limit) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.isLoadData = true
                if let data = Mapper<LabCategory>().mapArray(JSONObject: result) {
                    self.categoryDataSource = data
                    self.categoryCollectionView.reloadData()
                }
            }
        }
    }
    
    @objc func searchTapped(sender: UITapGestureRecognizer){
        let testSearchViewController = TestSearchViewController()
        testSearchViewController.addCustomBackButton()
        self.navigationController?.pushViewController(testSearchViewController, animated: true)
        
    }
    @IBAction func fabButtonTapped(_ sender: Any) {
        Utility.dialNumber()
    }
    
}

extension TestCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoadData {
            return categoryDataSource.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = TestCategoryCollectionViewCell.cellForCollectionView(collectionView: collectionView, atIndexPath: indexPath)
        if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(categoryDataSource[indexPath.item].categoryLogo)") {
            cell.categoryImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
            })
        }
        cell.upperLabel.text = categoryDataSource[indexPath.item].testCategoryName
        cell.lowerLabel.text = "Test"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: 181)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectTestViewController = SelectTestViewController()
        selectTestViewController.addCustomBackButton()
        selectTestViewController.labId =  self.categoryDataSource[indexPath.item].labId
        selectTestViewController.catId =  self.categoryDataSource[indexPath.item].testCatId
        self.navigationController?.pushViewController(selectTestViewController, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        
    }
}
