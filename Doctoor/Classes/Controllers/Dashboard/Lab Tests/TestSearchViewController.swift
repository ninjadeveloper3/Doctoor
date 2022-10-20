//
//  TestSearchViewController.swift
//  Doctoor
//
//  Created by DevBatch on 22/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper
import IQKeyboardManagerSwift

class TestSearchViewController: UIViewController {
    
    //MARK: - Variables

    var dataSource = [TestList]()
    
    var colorArray = [UIColor]()
    
    var filterButton = UIButton()
    
    var cartItems = [CartOrder]()

    //MARK: - Outlets

    @IBOutlet weak var searchIcon: UIImageView!
    
    @IBOutlet weak var searchInput: UITextField!
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    
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
//        searchInput.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        searchInput.becomeFirstResponder()
    }
    
    //MARK: - SetUp ViewController Methods

    func setUpViewController(){
        
        colorArray.removeAll()
        colorArray = Array(repeating: [#colorLiteral(red: 0.1578664184, green: 0.7639741302, blue: 0.873596549, alpha: 1), #colorLiteral(red: 0.1502691209, green: 0.8760904074, blue: 0.5964846611, alpha: 1), #colorLiteral(red: 0.1810388267, green: 0.2604581118, blue: 0.3767175376, alpha: 1), #colorLiteral(red: 0.5716004968, green: 0.4530112147, blue: 0.2566290498, alpha: 1)], count: 4)
        searchResultTableView.separatorStyle = .none
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "Select ", secondTitle: "Test")
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        let search = UITapGestureRecognizer(target: self, action: #selector(searchIconTapped(sender:)))
        searchIcon.addGestureRecognizer(search)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            self.searchInput.becomeFirstResponder()
        }
    }
    
    //MARK: - Private Methods
    
    @objc func searchIconTapped(sender: UITapGestureRecognizer){
        searchInput.text = ""
        self.searchIcon.image = #imageLiteral(resourceName: "search")
        self.searchIcon.bounds.size = CGSize(width: 30, height: 30)
//        self.getTestListApi()
        self.dataSource.removeAll()
        doSearchTests(TxtSearch: "a")
    }
    
    @IBAction func searchInputChanged(_ sender: UITextField) {
        if sender.text!.count > 0 {
            self.searchIcon.image = #imageLiteral(resourceName: "close")
            self.searchIcon.bounds.size = CGSize(width: 15, height: 15)
        }
        if sender.text!.isEmpty{
            self.dataSource.removeAll()
            doSearchTests(TxtSearch: "a")
        }
        else{
            let txt = sender.text!.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            doSearchTests(TxtSearch: txt)
        }
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
    
    func doSearchTests(TxtSearch: String){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.searchTests(searchItem: TxtSearch) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                self.dataSource.removeAll()
                self.searchResultTableView.reloadData()
            } else {
                if let data = Mapper<TestList>().mapArray(JSONObject: result) {
                    self.dataSource = data
        
                } else {
                  self.dataSource.removeAll()
                }
                self.colorArray = Array(repeating: [#colorLiteral(red: 0.1578664184, green: 0.7639741302, blue: 0.873596549, alpha: 1), #colorLiteral(red: 0.1502691209, green: 0.8760904074, blue: 0.5964846611, alpha: 1), #colorLiteral(red: 0.1810388267, green: 0.2604581118, blue: 0.3767175376, alpha: 1), #colorLiteral(red: 0.5716004968, green: 0.4530112147, blue: 0.2566290498, alpha: 1)], count: self.dataSource.count+10)
                self.searchResultTableView.reloadData()
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
    
    func getTestListApi() {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getTestList(page: -1, limit: 2000, labId: 1, categroyId: 2) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<TestList>().mapArray(JSONObject: result) {
                    self.dataSource = data
                    self.colorArray = Array(repeating: [#colorLiteral(red: 0.1578664184, green: 0.7639741302, blue: 0.873596549, alpha: 1), #colorLiteral(red: 0.1502691209, green: 0.8760904074, blue: 0.5964846611, alpha: 1), #colorLiteral(red: 0.1810388267, green: 0.2604581118, blue: 0.3767175376, alpha: 1), #colorLiteral(red: 0.5716004968, green: 0.4530112147, blue: 0.2566290498, alpha: 1)], count: data.count+10)
                    self.searchResultTableView.reloadData()
                }
            }
        }
    }
}

extension TestSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SelectTestTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        cell.colorView.backgroundColor = colorArray[indexPath.row]
        if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(dataSource[indexPath.row].logo)") {
            cell.logoImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
            })
        }
        cell.titleLabel.text = dataSource[indexPath.row].testName
        cell.descriptionLabel.text = dataSource[indexPath.row].description
        cell.priceLabel.text = "\(dataSource[indexPath.row].price)"
        cell.isCartSelected =  dataSource[indexPath.row].isCart
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let testDetailsViewController = TestDetailsViewController()
        testDetailsViewController.addCustomBackButton()
        testDetailsViewController.itemImageUrl = dataSource[indexPath.row].logo
        testDetailsViewController.itemTitle = dataSource[indexPath.row].testName
        testDetailsViewController.itemPrice = dataSource[indexPath.row].price
        testDetailsViewController.itemDescription = dataSource[indexPath.row].description
        testDetailsViewController.colorView = colorArray[indexPath.row]
        testDetailsViewController.dataSource = dataSource[indexPath.row]
        self.navigationController?.pushViewController(testDetailsViewController, animated: true)
    }
}

extension TestSearchViewController: SelectTestTableViewCellDelegate {
    func didCartItemTapped(cell: SelectTestTableViewCell, isAdd: Bool) {
        if let indexPath = searchResultTableView.indexPath(for: cell) {
            if isAdd {
                Utility.addUpdateInCart(productId: dataSource[indexPath.row].id, quantity: 1, productType: .Test, title: dataSource[indexPath.row].testName, price: dataSource[indexPath.row].price)
                
            } else {
                Utility.removeInCart(productId: dataSource[indexPath.row].id, productType: .Test)
            }
            filterButton.addBadge(number: Utility.getCartItems().count)
        }
    }
}
