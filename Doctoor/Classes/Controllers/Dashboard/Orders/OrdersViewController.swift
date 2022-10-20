//
//  OrdersViewController.swift
//  Doctoor
//
//  Created by DevBatch on 20/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import CarbonKit

class OrdersViewController: UIViewController {
    
    //MARK: - Variables
    
    let items = ["Products","Services","Rental"]
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "My ", secondTitle: "Orders")
        navLabel.attributedText = navTitle
        self.tabBarController?.navigationItem.titleView = navLabel
        self.tabBarController?.navigationItem.rightBarButtonItem =  UIBarButtonItem(image: #imageLiteral(resourceName: "cart"), style: .plain, target: self, action: #selector(addTapped(sender:)))
        
        let filterButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        filterButton.setImage(#imageLiteral(resourceName: "cart"), for: .normal)
        filterButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        filterButton.addBadge(number: Utility.getCartItems().count)
        let barButton = UIBarButtonItem(customView: filterButton)
        self.tabBarController?.navigationItem.rightBarButtonItem = barButton
        
        
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.batteryLevelChanged), name: NSNotification.Name(rawValue: kNNotificationIdentifier), object: nil)
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setupViewController() {
        
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNavigation.setSelectedColor(#colorLiteral(red: 0.2632602751, green: 0.1825990379, blue: 0.4616267681, alpha: 1), font: UIFont.appThemeSemiBoldFontWithSize(14.0))
        carbonTabSwipeNavigation.setNormalColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), font: UIFont.appThemeSemiBoldFontWithSize(14.0))
        carbonTabSwipeNavigation.setIndicatorColor(#colorLiteral(red: 0.2632602751, green: 0.1825990379, blue: 0.4616267681, alpha: 1))
        carbonTabSwipeNavigation.toolbar.tintColor = #colorLiteral(red: 0.2632602751, green: 0.1825990379, blue: 0.4616267681, alpha: 1)
        carbonTabSwipeNavigation.toolbar.barTintColor = .white
        carbonTabSwipeNavigation.toolbar.backgroundColor = .white
        carbonTabSwipeNavigation.toolbarHeight.constant = 55.0
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(Utility.getScreenWidth()/3, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(Utility.getScreenWidth()/3, forSegmentAt: 1)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(Utility.getScreenWidth()/3, forSegmentAt: 2)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
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
    
    @objc private func batteryLevelChanged(notification: NSNotification){
        self.tabBarController?.selectedIndex = 0
    }
}

extension OrdersViewController: CarbonTabSwipeNavigationDelegate {
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        let medicalServicesViewController = MyOrdersViewController()
        if index == 1 {
            medicalServicesViewController.isService = true
        }
        if index == 2 {
            medicalServicesViewController.isRental = true
        }
        return medicalServicesViewController
    }
}

