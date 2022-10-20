//
//  ServiceTypesViewController.swift
//  Doctoor
//
//  Created by DevBatch on 24/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class ServiceTypesViewController: UIViewController {


    //MARK: - Variables
    
    var selectedCity = Mapper<CityModel>().map(JSON: [:])!
        
    //MARK: - IBOutlets
    
    @IBOutlet weak var serviceView: HMView!
    
    @IBOutlet weak var equipmentVIew: UIView!
    
    @IBOutlet weak var equipmentPurchaseView: UIView!
    
    
    
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
                
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "Services ", secondTitle: "Type")
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
        
        let serviceViewGesture = UITapGestureRecognizer(target: self, action: #selector(serviceViewTapped(sender:)))
        serviceView.addGestureRecognizer(serviceViewGesture)
        
        let equipmentVIewGesture = UITapGestureRecognizer(target: self, action: #selector(equipmentViewTapped(sender:)))
        equipmentVIew.addGestureRecognizer(equipmentVIewGesture)
        
        let equipmentPurchaseViewGesture = UITapGestureRecognizer(target: self, action: #selector(equipmentPurchaseViewTapped(sender:)))
        equipmentPurchaseView.addGestureRecognizer(equipmentPurchaseViewGesture)
        
        
        
    }
    
    @objc func serviceViewTapped(sender: UITapGestureRecognizer){
        
        let serviceViewController = SelectServicesViewController()
        serviceViewController.addCustomBackButton()
        serviceViewController.selectedCity = self.selectedCity
        
        self.navigationController?.pushViewController(serviceViewController, animated: true)
    }
    
    @objc func equipmentViewTapped(sender: UITapGestureRecognizer){
        let serviceViewController = SelectServicesViewController()
        serviceViewController.addCustomBackButton()
        serviceViewController.selectedCity = self.selectedCity
        serviceViewController.isRental = true
        self.navigationController?.pushViewController(serviceViewController, animated: true)
    }
    
    @objc func equipmentPurchaseViewTapped(sender: UITapGestureRecognizer){
        
        let equipmentViewController = EquipmentViewController()
        equipmentViewController.addCustomBackButton()
        equipmentViewController.selectedCity = self.selectedCity
        self.navigationController?.pushViewController(equipmentViewController, animated: true)
    }
    
    
    @objc func uploadViewTapped(sender: UITapGestureRecognizer){
        
        let uploadViewController = PerscriptionViewController()
        uploadViewController.addCustomBackButton()
        uploadViewController.isHome = false
        
        self.navigationController?.pushViewController(uploadViewController, animated: true)
    }
    
    @objc func addTapped(sender: UIBarButtonItem) {
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
    
}
