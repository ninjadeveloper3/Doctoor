//
//  SelectTestViewController.swift
//  Doctoor
//
//  Created by DevBatch on 23/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class SelectTestViewController: UIViewController {
    
    //MARK: - Variables
    
    var dataSource = [TestList]()
    
    var isLoadData = false
    
    var cartItems = [CartOrder]()
    
    var colorArray = [UIColor]()
    
    var labId = 0
    
    var catId = 0
    
    var isDataLoading:Bool=false
    
    var pageNo:Int=1
    
    var limit:Int=20
    
    var offset:Int=0 //pageNo*limit
    
    var didEndReached:Bool=false
    
    var filterButton = UIButton()
    
    var isOtherCat = false
    
    //MARK: - Outlets
    
    @IBOutlet weak var selectTestTableView: UITableView!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        filterButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        filterButton.setImage(#imageLiteral(resourceName: "cart"), for: .normal)
        filterButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        filterButton.addBadge(number: Utility.getCartItems().count)
        let barButton = UIBarButtonItem(customView: filterButton)
        self.navigationItem.rightBarButtonItem = barButton
        dataSource.removeAll()
        pageNo = 1
        getTestListApi(pageNo: pageNo, limit: limit)
    }
    
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        colorArray.removeAll()
        colorArray = Array(repeating: [#colorLiteral(red: 0.1578664184, green: 0.7639741302, blue: 0.873596549, alpha: 1), #colorLiteral(red: 0.1502691209, green: 0.8760904074, blue: 0.5964846611, alpha: 1), #colorLiteral(red: 0.1810388267, green: 0.2604581118, blue: 0.3767175376, alpha: 1), #colorLiteral(red: 0.5716004968, green: 0.4530112147, blue: 0.2566290498, alpha: 1)], count: 4)
        selectTestTableView.separatorStyle = .none
        
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "Select ", secondTitle: "Test")
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
    }
    
    //MARK: - Private Methods
    
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
    
    
    func getTestListApi(pageNo: Int, limit: Int) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getTestList(page: pageNo, limit: limit, labId: labId, categroyId: catId) { (response, result, error, message)  in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<TestList>().mapArray(JSONObject: result) {
                    if data.count > 0 {
                        self.isLoadData = true
                        self.dataSource.append(contentsOf: data)
                        self.selectTestTableView.reloadData()
                        self.cartItems = Utility.getCartItems()
                        for data in self.dataSource {
                            for (index, _) in self.cartItems.enumerated() {
                                if data.id == self.cartItems[index].productId {
                                    data.isCart = true
                                }
                            }
                        }
                        self.isDataLoading = false
                        self.colorArray = Array(repeating: [#colorLiteral(red: 0.1578664184, green: 0.7639741302, blue: 0.873596549, alpha: 1), #colorLiteral(red: 0.1502691209, green: 0.8760904074, blue: 0.5964846611, alpha: 1), #colorLiteral(red: 0.1810388267, green: 0.2604581118, blue: 0.3767175376, alpha: 1), #colorLiteral(red: 0.5716004968, green: 0.4530112147, blue: 0.2566290498, alpha: 1)], count: self.dataSource.count)
                        
                    } else {
                        self.isDataLoading = true
                    }
                }
            }
        }
    }
}

extension SelectTestViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoadData {
            return self.dataSource.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SelectTestTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        cell.colorView.backgroundColor = colorArray[indexPath.row]
        if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(dataSource[indexPath.row].logo)") {
            cell.logoImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
            })
        }
        if dataSource[indexPath.row].isCart {
            cell.cartImageView.image = #imageLiteral(resourceName: "select-cart")
            
        } else {
            cell.cartImageView.image = #imageLiteral(resourceName: "unselect-cart")
        }
        cell.isCartSelected =  dataSource[indexPath.row].isCart
        cell.titleLabel.text = dataSource[indexPath.row].testName
        cell.descriptionLabel.text = dataSource[indexPath.row].description
        cell.priceLabel.text = "\(dataSource[indexPath.row].price)"
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let testDetailsViewController = TestDetailsViewController()
        testDetailsViewController.addCustomBackButton()
        testDetailsViewController.isOtherCat = isOtherCat
        testDetailsViewController.itemImageUrl = dataSource[indexPath.row].logo
        testDetailsViewController.itemTitle = dataSource[indexPath.row].testName
        testDetailsViewController.itemPrice = dataSource[indexPath.row].price
        testDetailsViewController.itemDescription = dataSource[indexPath.row].description
        testDetailsViewController.colorView = colorArray[indexPath.row]
        testDetailsViewController.dataSource = dataSource[indexPath.row]
        self.navigationController?.pushViewController(testDetailsViewController, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
//        isDataLoading = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        
        if ((selectTestTableView.contentOffset.y + selectTestTableView.frame.size.height) >= selectTestTableView.contentSize.height)
        {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo=self.pageNo+1
                self.limit=self.limit+10
                //                loadCallLogData(offset: self.offset, limit: self.limit)
                getTestListApi(pageNo: self.pageNo, limit: self.limit)
                
            }
        }
    }
}

extension SelectTestViewController: SelectTestTableViewCellDelegate {
    func didCartItemTapped(cell: SelectTestTableViewCell, isAdd: Bool) {
        if let indexPath = selectTestTableView.indexPath(for: cell) {
            if isAdd {
                Utility.addUpdateInCart(productId: dataSource[indexPath.row].id, quantity: 1, productType: .Test, title: dataSource[indexPath.row].testName, price: dataSource[indexPath.row].price)
                
            } else {
                Utility.removeInCart(productId: dataSource[indexPath.row].id, productType: .Test)
            }
            filterButton.addBadge(number: Utility.getCartItems().count)
        }
    }
}
