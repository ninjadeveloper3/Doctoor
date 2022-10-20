//
//  OtherCatagoriesViewController.swift
//  Doctoor
//
//  Created by DevBatch on 27/12/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import CarbonKit

class OtherCatagoriesViewController: UIViewController {
    
    //MARK:- Variables
    
    var filterButton = UIButton()
    
    let items = ["Popular Equipments","Popular Tests","Medical Services"]
    
    //MARK:- IBOutlets
    

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
    }

    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "Other ", secondTitle: "Catagories")
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
//        let search = UITapGestureRecognizer(target: self, action: #selector(searchTapped(sender:)))
//        searchView.addGestureRecognizer(search)
        
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNavigation.setSelectedColor(#colorLiteral(red: 0.2632602751, green: 0.1825990379, blue: 0.4616267681, alpha: 1), font: UIFont.appThemeSemiBoldFontWithSize(12.0))
        carbonTabSwipeNavigation.setNormalColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), font: UIFont.appThemeSemiBoldFontWithSize(12.0))
        carbonTabSwipeNavigation.setIndicatorColor(#colorLiteral(red: 0.2632602751, green: 0.1825990379, blue: 0.4616267681, alpha: 1))
        carbonTabSwipeNavigation.toolbar.tintColor = #colorLiteral(red: 0.2632602751, green: 0.1825990379, blue: 0.4616267681, alpha: 1)
        carbonTabSwipeNavigation.toolbar.barTintColor = .white
        carbonTabSwipeNavigation.toolbar.backgroundColor = .white
        carbonTabSwipeNavigation.toolbarHeight.constant = 55.0
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(Utility.getScreenWidth()/3, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(Utility.getScreenWidth()/3, forSegmentAt: 1)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
    }
    
    //MARK:- Private Methods
    
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

}

extension OtherCatagoriesViewController: CarbonTabSwipeNavigationDelegate {
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        let medicalServicesViewController = OtherCatagoriesController()
        if index == 1 {
            medicalServicesViewController.isPopularTest = true
        }
        if index == 2 {
            medicalServicesViewController.isPopularServices = true
        }
        return medicalServicesViewController
    }
}
