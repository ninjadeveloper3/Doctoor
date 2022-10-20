//
//  BasicInfoViewController.swift
//  Doctoor
//
//  Created by DevBatch on 01/11/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper
import SlideMenuControllerSwift


class BasicInfoViewController: UIViewController {
    
    //MARK: - Variables
    
    var segmentCount = 0
    
    var userId = 0
    
    var datasource = Mapper<Facebook>().map(JSON: [:])!
    
    var signupDataSource = Mapper<SignUpUser>().map(JSON: [:])!
    
    
    var segmentedControl: GLXSegmentedControl!
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var phoneNumberTextInput: MBUITextField!{
        didSet {
            phoneNumberTextInput.setIcon(#imageLiteral(resourceName: "login"), width: 20, height: 20)
            phoneNumberTextInput.isMobileNumberTextField = true
            
        }
        
    }
    
    @IBOutlet weak var sagmentView: HMView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("data source-->",datasource)
        setUpViewController()
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        
        let appearance = GLXSegmentAppearance()
        appearance.segmentOnSelectionColor = #colorLiteral(red: 0.9332318306, green: 0.9333917499, blue: 0.933221817, alpha: 1)
        
        appearance.segmentOffSelectionColor = UIColor.white
        appearance.titleOnSelectionFont = UIFont.systemFont(ofSize: 15.0)
        appearance.titleOffSelectionFont = UIFont.systemFont(ofSize: 15.0)
        appearance.contentVerticalMargin = 10.0
        appearance.dividerColor =  .lightGray
        appearance.titleOnSelectionColor = .black
        appearance.titleOffSelectionColor = .black
        
        let segmentFrame = CGRect(x: 0, y: 0, width: self.sagmentView.bounds.width - 30 , height: self.sagmentView.frame.size.height)
        self.segmentedControl = GLXSegmentedControl(frame: segmentFrame, segmentAppearance: appearance)
        self.segmentedControl.backgroundColor = UIColor.clear
        
        self.segmentedControl.layer.cornerRadius = 5.0
        self.segmentedControl.layer.borderColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        self.segmentedControl.layer.borderWidth = 1.0
        
        self.segmentedControl.addSegment(withTitle:"Male", onSelectionImage: #imageLiteral(resourceName: "male"), offSelectionImage:  #imageLiteral(resourceName: "male"))
        self.segmentedControl.addSegment(withTitle:"Female", onSelectionImage:  #imageLiteral(resourceName: "female"), offSelectionImage:  #imageLiteral(resourceName: "female"))
        
        
        segmentCount = 2
        self.segmentedControl.addTarget(self, action: #selector(self.selectSegmentInsegmentedControl(segmentedControl:)), for: .valueChanged)
        
        // Set segment with index 0 as selected by default
        self.segmentedControl.selectedSegmentIndex = 0
        self.sagmentView.addSubview(self.segmentedControl)
    }
    
    @objc func selectSegmentInsegmentedControl(segmentedControl: GLXSegmentedControl) {
        print("Select segment at index: \(segmentedControl.selectedSegmentIndex)")
    }
    
    @IBAction func backPress(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submitTapped(_ sender: Any) {
        if phoneNumberTextInput.text!.isEmpty {
            NSError.showErrorWithMessage(message: "Empty Phone Field", viewController: self, type: .error, isNavigation: false)
            return
        }
        else{
            if phoneNumberTextInput.text!.count != 12
            {
                NSError.showErrorWithMessage(message: "Invalid phone format", viewController: self, type: .error, isNavigation: false)
                return
            }
        }
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.fbSignInWithCompleteInfo(userId: userId,phone: phoneNumberTextInput.text!,gender: segmentedControl.selectedSegmentIndex == 0 ? "Male" : "Female") { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self, isNavigation: false)
                
            } else {
                var id = 0
                if let data = result!["id"] {
                    id = data as! Int
                    UserDefaults.standard.set(self.signupDataSource.token, forKey: kToken)
                    let verificationViewController = VerificationViewController()
                    verificationViewController.userId = id
                    self.navigationController?.pushViewController(verificationViewController, animated: true)
                }
            }
        }
    }
    func homeViewPresentation() {
        Utility.setUpNavDrawerController()
        let leftMenuViewController = LeftNavDrawerViewController()
        let navController = UINavigationController()
        navController.setupAppThemeNavigationBar()
        navController.viewControllers = [Utility.tabController]
        let slideMenuController = SlideMenuController(mainViewController: navController, leftMenuViewController: leftMenuViewController)
        slideMenuController.modalPresentationStyle = .fullScreen
        self.present(slideMenuController, animated: true, completion: nil)
    }
    
}
