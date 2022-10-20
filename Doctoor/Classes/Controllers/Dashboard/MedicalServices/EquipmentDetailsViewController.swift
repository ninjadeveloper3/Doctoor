//
//  EquipmentDetailsViewController.swift
//  Doctoor
//
//  Created by DevBatch on 25/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class EquipmentDetailsViewController: UIViewController {
    
    //MARK: - Variables
    
    var availableQty = 0
    
    var selectedQty = 0
    
    var selectedEquipment = Mapper<MedicalEquip>().map(JSON: [:])!
    
    var filterButton = UIButton()
    
    var isHome = false
    
    var totalPrice = 0.0
    
    var singleItemPrice = 0.0
    
    //MARK: - Outlets
    
    @IBOutlet weak var addToCartView: UIView!
    
    @IBOutlet weak var addToCartLabel: UILabel!
    
    @IBOutlet weak var shoppingView: UIView!
    
    @IBOutlet weak var equipmentImage: UIImageView!
    
    @IBOutlet weak var equipmentName: UILabel!
    
    @IBOutlet weak var brandName: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var aboutEquipment: UILabel!
    
    @IBOutlet weak var quantity: UILabel!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
        availableQty = selectedEquipment.quantity
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filterButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        filterButton.setImage(#imageLiteral(resourceName: "cart"), for: .normal)
        filterButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        filterButton.addBadge(number: Utility.getCartItems().count)
        let barButton = UIBarButtonItem(customView: filterButton)
        self.navigationItem.rightBarButtonItem = barButton
        
        //check item in the cart
        for items in Utility.getCartItems() {
            if (items.productId == selectedEquipment.id && items.productType == ProductType.Equipment.rawValue) {
                addToCartLabel.text = "Remove from the cart"
            }
        }
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        navigationItem.title = "Details"
        if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(selectedEquipment.image)") {
            equipmentImage.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
            })
        }
        equipmentName.text! = selectedEquipment.equipName
        brandName.text! = selectedEquipment.brand
        price.text! = String(selectedEquipment.price)
        selectedQty = Int(quantity.text!)!
        aboutEquipment.text! = selectedEquipment.description
        singleItemPrice = selectedEquipment.price
        let addtoCartGesture = UITapGestureRecognizer(target: self, action: #selector(addtoCartViewTapped(sender:)))
        addToCartView.addGestureRecognizer(addtoCartGesture)
        
        let shoppingGesture = UITapGestureRecognizer(target: self, action: #selector(shoppingViewTapped(sender:)))
        shoppingView.addGestureRecognizer(shoppingGesture)
        
        if isHome {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
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
    
    @IBAction func plusQuatityTapped(_ sender: Any) {
        
        if selectedQty == 99 {
            return
        }
        selectedQty += 1
        totalPrice = singleItemPrice * Double(selectedQty)
        quantity.text! = String(selectedQty)
        price.text! = "\(totalPrice)"
    }
    
    @IBAction func minusQuantityTapped(_ sender: Any) {

        if selectedQty == 1 {
            return
        }
        selectedQty -= 1
        totalPrice = singleItemPrice * Double(selectedQty)
        quantity.text! = String(selectedQty)
        price.text! = "\(totalPrice)"
        
    }
    
    @objc func addtoCartViewTapped(sender: UITapGestureRecognizer){
        
        
        for items in Utility.getCartItems() {
            if (items.productId == selectedEquipment.id && items.productType == ProductType.Equipment.rawValue) {
                Utility.removeInCart(productId: items.productId, productType: .Equipment)
                filterButton.addBadge(number: Utility.getCartItems().count)
                addToCartLabel.text = "Add to cart"
                return
            }
        }
        
        Utility.addUpdateInCart(productId: selectedEquipment.id, quantity: selectedQty, productType: .Equipment, title: selectedEquipment.equipName, price: selectedEquipment.price, description: selectedEquipment.description)
        
        filterButton.addBadge(number: Utility.getCartItems().count)
        addToCartLabel.text = "Remove from the cart"
    }
    
    @objc func shoppingViewTapped(sender: UITapGestureRecognizer){
        if isHome {
            self.dismiss(animated: true, completion: nil)
        
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func fabButtonTapped(_ sender: Any) {
        Utility.dialNumber()
    }
    
}
