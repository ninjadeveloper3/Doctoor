//
//  LeftNavDrawerViewController.swift
//  Doctoor
//
//  Created by DevBatch on 20/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class LeftNavDrawerViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    
    let navImages: [UIImage] = [#imageLiteral(resourceName: "popular-item") , #imageLiteral(resourceName: "popular-item") , #imageLiteral(resourceName: "upload-prescription"), #imageLiteral(resourceName: "about-us"),  #imageLiteral(resourceName: "about-us"), #imageLiteral(resourceName: "stomach ache") , #imageLiteral(resourceName: "fever (1)"), #imageLiteral(resourceName: "high blood pressure") , #imageLiteral(resourceName: "cough-and-cold"), #imageLiteral(resourceName: "female health"), #imageLiteral(resourceName: "nail health"), #imageLiteral(resourceName: "Diabetes Management"), #imageLiteral(resourceName: "Other-Categories")]
    let navString: [String] = [
        "My Lab reports",
        "My Lab reports",
        "My Prescriptions",
        "About Us",
        "About Us",
        "Stomach Ache", //"Health & Fitness",
        "Fever", //"Health & Fitness",
        "High Blood Pressure", //"Sexual Wellness",
        "Cough & Cold", //"Feminine Care",
        "Female Health",//"First Aid",
        "Skin, Hair & Nail Care", //"Stomach Care",
        "Diabetes", //"Body Care",
        "Other Categories",
    ]
    
    
    let navController = UINavigationController()
    let labReportNavigation = UINavigationController()
    let prescriptionNavigation = UINavigationController()
    let otherCatagoriesNavigation = UINavigationController()
    let aboutUsNavigation = UINavigationController()
    let medicineNavigation = UINavigationController()
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    //MARK: - SetUp View Controller Methods
    
    func setUpViewController() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        
        Utility.setUpNavDrawerController()
        navController.setupAppThemeNavigationBar()
        navController.viewControllers = [Utility.tabController]
        
        let labReportsViewController = LabReportsViewController()
        labReportsViewController.addLeftBarButtonWithImage(#imageLiteral(resourceName: "navigation-icon"))
        labReportNavigation.viewControllers = [labReportsViewController]
        labReportNavigation.setupAppThemeNavigationBar()
        
        let prescriptionsViewController = MyPrescriptionsViewController()
        prescriptionsViewController.addLeftBarButtonWithImage(#imageLiteral(resourceName: "navigation-icon"))
        prescriptionNavigation.viewControllers = [prescriptionsViewController]
        prescriptionNavigation.setupAppThemeNavigationBar()
        
        let otherCatagoriesViewController = OtherCatagoriesViewController()
        otherCatagoriesViewController.addLeftBarButtonWithImage(#imageLiteral(resourceName: "navigation-icon"))
        otherCatagoriesNavigation.viewControllers = [otherCatagoriesViewController]
        otherCatagoriesNavigation.setupAppThemeNavigationBar()
        
        let aboutUsViewController =  AboutUsViewController()
        aboutUsViewController.addLeftBarButtonWithImage(#imageLiteral(resourceName: "navigation-icon"))
        aboutUsNavigation.viewControllers = [aboutUsViewController]
        aboutUsNavigation.setupAppThemeNavigationBar()
    }
}

// MARK: - UITableView Delegate & DataSource

extension LeftNavDrawerViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return navString.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let header = DrawerHeaderTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                header.delegate = self
                
                if let username = UserDefaults.standard.object(forKey: kUserFullName) as? String {
                    header.usernameLabel.text! = username
                }
                
                if let isSocial = UserDefaults.standard.object(forKey: kUserIsSocial) as? Bool {
                    if isSocial {
                        if let test = UserDefaults.standard.object(forKey: kUserSocialAvatar) {
                            let url = URL(string: test as! String)!
                            header.profileImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                            })
                        }
                        
                    } else {
                        if let avatar = UserDefaults.standard.object(forKey: kUserAvatar) as? String {
                            if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(avatar)") {
                                header.profileImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                                })
                            }
                        }
                    }
                }
                if let avatar = UserDefaults.standard.object(forKey: kUserAvatar) as? String {
                    if let url = URL(string: "\(kImageDownloadProfileBaseUrl)storage/\(avatar)") {
                        header.profileImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
                        })
                    }
                }
                return header
            }
            
            if indexPath.row == 4 {
                let categoryCell = CategoryTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
                return categoryCell
            }
            
            let cell = DrawerItemTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            cell.itemLabel.text = navString[indexPath.row]
            cell.itemImageView.image = navImages[indexPath.row]
            return cell
            
        } else {
            let versionCell = VersionTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            return versionCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.slideMenuController()?.changeMainViewController(navController, close: true)
            }
            
            if indexPath.row == 1 {
                
                if Utility.isKeyPresentInUserDefaults(key: kToken) {
//                    Utility.deleteAllItems()
                    self.slideMenuController()?.changeMainViewController(labReportNavigation, close: true)
                
                } else {
                    self.slideMenuController()?.changeMainViewController(navController, close: true)
                    let moveToLoginViewController = MoveToLoginViewController()
                    moveToLoginViewController.modalPresentationStyle = .overCurrentContext
                    self.present(moveToLoginViewController, animated: true, completion: nil)
                }
            }
            
            if indexPath.row == 2 {
                
                
                if Utility.isKeyPresentInUserDefaults(key: kToken) {
                    //                    Utility.deleteAllItems()
                    self.slideMenuController()?.changeMainViewController(prescriptionNavigation, close: true)
                    
                } else {
                    self.slideMenuController()?.changeMainViewController(navController, close: true)
                    let moveToLoginViewController = MoveToLoginViewController()
                    moveToLoginViewController.modalPresentationStyle = .overCurrentContext
                    self.present(moveToLoginViewController, animated: true, completion: nil)
                }
            }
            
            if indexPath.row == 3 { //prescription
                self.slideMenuController()?.changeMainViewController(aboutUsNavigation, close: true)
            }
            if indexPath.row == 4 {
                
            }
            if indexPath.row > 4 {
                
                let medicineViewController  = FaminineViewController()
                
                if indexPath.row == 5 {
                    medicineViewController.id = 16
                }
                
                if indexPath.row == 6 {
                    medicineViewController.id = 9
                }
                
                if indexPath.row == 7 {
                    medicineViewController.id = 14
                }
                
                if indexPath.row == 8 {
                    medicineViewController.id = 8
                }
                
                if indexPath.row == 9 {
                    medicineViewController.id = 3
                }
                
                if indexPath.row == 10 {
                    medicineViewController.id = 7
                }
                if indexPath.row == 11 {
                    medicineViewController.id = 11
                }
                
                if indexPath.row == 12 {
                    self.slideMenuController()?.changeMainViewController(otherCatagoriesNavigation, close: true)
                    return
                }
                
                medicineViewController.addLeftBarButtonWithImage(#imageLiteral(resourceName: "navigation-icon"))
                medicineNavigation.viewControllers = [medicineViewController]
                medicineNavigation.setupAppThemeNavigationBar()
                self.slideMenuController()?.changeMainViewController(medicineNavigation, close: true)
            }
        }
    }
}

extension LeftNavDrawerViewController : DrawerHeaderTableViewCellDelegate{
    func didFinishTask() {
        
        if Utility.isKeyPresentInUserDefaults(key: kToken){
            Utility.showLoading(viewController: self)
            APIClient.sharedClient.signOut() { (response, result, error, message) in
                Utility.hideLoading(viewController: self)
                //                if error != nil {
                //                    error?.showErrorBelowNavigation(viewController: self)
                //
                //                } else {
                Utility.deleteAllUserDefaults()
                Utility.deleteAllItems()
                let navigationController = UINavigationController()
                navigationController.navigationBar.isTranslucent = false
                let baseViewController = BaseViewController()
                navigationController.viewControllers = [baseViewController]
                navigationController.navigationBar.isHidden = true
                UIApplication.shared.keyWindow!.replaceRootViewControllerWith(navigationController, animated: true, completion: nil)
                //}
            }
            
        } else {
            
            let navigationController = UINavigationController()
            navigationController.navigationBar.isTranslucent = false
            let baseViewController = BaseViewController()
            navigationController.viewControllers = [baseViewController]
            navigationController.navigationBar.isHidden = true
            UIApplication.shared.keyWindow!.replaceRootViewControllerWith(navigationController, animated: true, completion: nil)
        }
    }
}
