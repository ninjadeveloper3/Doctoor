//
//  TestDetailsViewController.swift
//  Doctoor
//
//  Created by DevBatch on 23/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class TestDetailsViewController: UIViewController {

    //MARK: - Variables
    
    var colorView = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    
    var itemDescription = ""
    
    var itemTitle = ""
    
    var itemPrice = 0.0
    
    var itemImageUrl = ""
    
    var dataSource = Mapper<TestList>().map(JSON: [:])!
    
    var filterButton = UIButton()
    
    var isHome = false
    
    var isOtherCat = false
    
    //MARK: - Outlets
    
    @IBOutlet weak var contiueShoppingView: UIView!
    
    @IBOutlet weak var addToCartView: UIView!
    
    @IBOutlet weak var addToCartLabel: UILabel!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var colorBackView: HMView!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
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
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "Test ", secondTitle: "Details")
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
        let addtoCartGesture = UITapGestureRecognizer(target: self, action: #selector(addtoCartViewTapped(sender:)))
        addToCartView.addGestureRecognizer(addtoCartGesture)
        
        let shoppingGesture = UITapGestureRecognizer(target: self, action: #selector(shoppingViewTapped(sender:)))
        contiueShoppingView.addGestureRecognizer(shoppingGesture)
        
        titleLabel.text = itemTitle
        descriptionLabel.text = itemDescription
        priceLabel.text = "\(itemPrice)"
        if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(itemImageUrl)") {
            logoImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
            })
        }
        colorBackView.backgroundColor = colorView
        
        if isHome {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        }
        
        //check item in the cart
        for items in Utility.getCartItems() {
            if (items.productId == dataSource.id && items.productType == ProductType.Test.rawValue) {
                addToCartLabel.text = "Remove from the cart"
            }
        }
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
    
    @objc func backButtonTapped(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addtoCartViewTapped(sender: UITapGestureRecognizer){
        
        for items in Utility.getCartItems() {
            if (items.productId == dataSource.id && items.productType == ProductType.Test.rawValue) {
                Utility.removeInCart(productId: items.productId, productType: .Test)
//                Utility.deleteInCart(id: items.productId)
                filterButton.addBadge(number: Utility.getCartItems().count)
                addToCartLabel.text = "Add to cart"
                return
            }
        }
        
        
        Utility.addUpdateInCart(productId: dataSource.id, quantity: 1, productType: .Test, title: dataSource.testName, price: dataSource.price)
        filterButton.addBadge(number: Utility.getCartItems().count)
        addToCartLabel.text = "Remove from the cart"
    }
    
    @objc func shoppingViewTapped(sender: UITapGestureRecognizer){
        if isOtherCat {
            self.navigationController?.popViewController(animated: true)

        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func fabButtonTapped(_ sender: Any) {
        Utility.dialNumber()
    }
}
