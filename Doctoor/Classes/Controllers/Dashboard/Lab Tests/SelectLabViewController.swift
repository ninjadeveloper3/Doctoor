//
//  SelectLabViewController.swift
//  Doctoor
//
//  Created by Zeeshan Haider on 23/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import ObjectMapper


class SelectLabViewController: UIViewController {
    
    //MARK: - Variables
    
    var dataSource = [LabTest]()
    
    var cartItems = [CartOrder]()
    
    let badgeLable = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: 16, height: 16))
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var selectLabTableView: UITableView!
    
    @IBOutlet weak var uploadPrescriptionView: UIView!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cartItems = Utility.getCartItems()
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
        
        selectLabTableView.delegate = self
        selectLabTableView.dataSource = self
        selectLabTableView.separatorStyle = .none
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "Select ", secondTitle: "Test")
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        
        let uploadGesture = UITapGestureRecognizer(target: self, action: #selector(uploadViewTapped(sender:)))
        uploadPrescriptionView.addGestureRecognizer(uploadGesture)
        doGetLabTestList()
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
    
    @objc func uploadViewTapped(sender: UITapGestureRecognizer){
        
        
        if Utility.isKeyPresentInUserDefaults(key: kToken) {
            let navigationController = UINavigationController()
            navigationController.setupAppThemeNavigationBar()
            let pviewController = PerscriptionViewController()
            pviewController.isHome = false
            pviewController.prescFor = "manual"
            navigationController.viewControllers = [PerscriptionViewController()]
            self.present(navigationController, animated: true, completion: nil)
        }
        else{
            let moveToLoginViewController = MoveToLoginViewController()
            moveToLoginViewController.modalPresentationStyle = .overCurrentContext
            self.present(moveToLoginViewController, animated: true, completion: nil)
        }
        
        
    }
    
    
    @IBAction func fabButtonTapped(_ sender: Any) {
        Utility.dialNumber()
    }
    
    func doGetLabTestList(){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getLabList() { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<LabTest>().mapArray(JSONObject: result) {
                    self.dataSource = data
                    self.selectLabTableView.reloadData()
                }
            }
        }
    }
}

extension SelectLabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let labCell = LabsTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        labCell.labNameTitle.text = self.dataSource[indexPath.row].labName
        let imageUrl = self.dataSource[indexPath.row].logo
        let imageurl = imageUrl.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        print("Complete URL", "\(kImageDownloadBaseUrl)storage/\(imageurl)")
        if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(imageurl)") {
            print("url", url)
            labCell.labTestLogo.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false, completion: {response in
            })
        }
        return labCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let testCategoryViewController = TestCategoryViewController()
        testCategoryViewController.addCustomBackButton()
       
        testCategoryViewController.labId = self.dataSource[indexPath.row].id
        self.navigationController?.pushViewController(testCategoryViewController, animated: true)
    }
}
