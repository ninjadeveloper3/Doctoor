//
//  NotificationViewController.swift
//  Doctoor
//
//  Created by DevBatch on 19/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class NotificationViewController: UIViewController {
    
    //MARK: - Variables
    
    var dataSource = [Notifications]()
    
    var isLoadData = false
    
    var isService = false
    
    var isRental = false
    
    var isDataLoading:Bool=false
    
    var pageNo:Int=1
    
    var limit:Int=20
    
    var offset:Int=0 //pageNo*limit
    
    //MARK: - Outlets
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "", secondTitle: "Notifications")
        navLabel.attributedText = navTitle
        self.tabBarController?.navigationItem.titleView = navLabel
        self.tabBarController?.navigationItem.rightBarButtonItem =  UIBarButtonItem(image: UIImage(), style: .plain, target: self, action: nil)
        
        if Utility.isKeyPresentInUserDefaults(key: kToken) {
            pageNo = 1
            notificationsApiCall(pageNo: pageNo, limit: limit, isViewWill: true)
        
          } else {
            NSError.showErrorWithMessage(message: "Please login first to see notifications history", viewController: self, type: .error, isNavigation: true)
        }
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        notificationTableView.estimatedRowHeight = 200
        notificationTableView.separatorStyle = .none
    }
    
    //MARK: - Private Methods
    
    func notificationsApiCall(pageNo: Int, limit: Int, isViewWill: Bool = false) {
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getNotifications(pageNo: pageNo, limit: limit) { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if isViewWill {
                self.dataSource.removeAll()
            }
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                self.isLoadData = true
                if let data = Mapper<Notifications>().mapArray(JSONObject: result) {
                    if data.count > 0 {
                        self.dataSource.append(contentsOf: data)
                    }
                    self.notificationTableView.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func fabButtonTapped(_ sender: Any) {
        Utility.dialNumber()
    }
    
    func dateFormatter(rowDate: String, date: Bool) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy"
        
        let timeFormatterPrint = DateFormatter()
        timeFormatterPrint.dateFormat = "HH:mm:ss"
        
        var formatedDate = ""
        
        if date {
            if let date = dateFormatterGet.date(from: rowDate) {
                formatedDate = dateFormatterPrint.string(from: date)
                
                
            } else {
                print("There was an error decoding the string")
            }
        }
        else{
            if let Time = dateFormatterGet.date(from: rowDate){
                print("formated time->",timeFormatterPrint.string(from: Time))
                formatedDate = timeFormatterPrint.string(from: Time)
            }
            else {
                print("There was an error decoding the string")
            }
        }
        return formatedDate
    }
}

// MARK: - UITableView Delegate & DataSource

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoadData {
            return dataSource.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = NotificationTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
//        cell.titleLabel.text = self.dataSource[indexPath.row].noteTitle
//        cell.descriptionLabel.text = self.dataSource[indexPath.row].noteBody
        cell.date.text = self.dateFormatter(rowDate: dataSource[indexPath.row].createdAt, date: true)
        cell.time.text = self.dateFormatter(rowDate: dataSource[indexPath.row].createdAt, date: false)
        if dataSource[indexPath.row].noteType == 1 { //Order history notification
            cell.notificationImage.image = #imageLiteral(resourceName: "order (1)")
            cell.titleLabel.text = self.dataSource[indexPath.row].orderId+" | Rs. "+"\(self.dataSource[indexPath.row].totalAmount)"
            cell.descriptionLabel.text = self.dataSource[indexPath.row].noteBody
        }
        if dataSource[indexPath.row].noteType == 2 { //Lab reports notification
            cell.notificationImage.image = #imageLiteral(resourceName: "notification-1")
            cell.titleLabel.text = self.dataSource[indexPath.row].orderId
            cell.descriptionLabel.text = self.dataSource[indexPath.row].noteBody
        }
        if dataSource[indexPath.row].noteType == 3 || dataSource[indexPath.row].noteType == 4 || dataSource[indexPath.row].noteType == 5 || dataSource[indexPath.row].noteType == 6 { //Service
            cell.titleLabel.text = self.dataSource[indexPath.row].noteBody
            cell.descriptionLabel.text = self.dataSource[indexPath.row].noteTitle
            cell.notificationImage.image = #imageLiteral(resourceName: "Home Medics placeholder white (1)")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let navigationController = UINavigationController()
        navigationController.setupAppThemeNavigationBar()
        
        if dataSource[indexPath.row].noteType == 1 && dataSource[indexPath.row].paid != 0 { //Order history notification
//            self.tabBarController?.selectedIndex = 2
        }
        if dataSource[indexPath.row].noteType == 2  { //Lab reports notification

            let labReportsViewController = LabReportsViewController()
            labReportsViewController.isNotification = true
            navigationController.viewControllers = [labReportsViewController]
            self.present(navigationController, animated: true, completion: nil)
        }
        
        if (dataSource[indexPath.row].noteType == 3 || dataSource[indexPath.row].noteType == 4 || dataSource[indexPath.row].noteType == 5 || dataSource[indexPath.row].noteType == 6) && dataSource[indexPath.row].paid == 0 {
            
            let checkOutView = CheckoutStepThreeViewController()
            checkOutView.isPresented = true
            checkOutView.totalAmount = Double(dataSource[indexPath.row].totalAmount)
            checkOutView.addCustomBackButton()
            checkOutView.notificationData = dataSource[indexPath.row]
            
            if dataSource[indexPath.row].noteType == 4 || dataSource[indexPath.row].noteType == 6 { //if bill amount is more then max limit
                checkOutView.COD = true
            }
            if dataSource[indexPath.row].noteType == 3 || dataSource[indexPath.row].noteType == 4{
                self.isService = true
                self.isRental = false
            }
            if dataSource[indexPath.row].noteType == 5 || dataSource[indexPath.row].noteType == 6 {
                self.isRental = true
                self.isService = false
            }
            
            checkOutView.isService = self.isService
            checkOutView.isRental = self.isRental
            navigationController.viewControllers = [checkOutView]
            self.present(navigationController, animated: true, completion: nil)
        }
        
        if (dataSource[indexPath.row].noteType == 3 || dataSource[indexPath.row].noteType == 4 || dataSource[indexPath.row].noteType == 5 || dataSource[indexPath.row].noteType == 6) && dataSource[indexPath.row].paid == 1 {
            
            NSError.showErrorWithMessage(message: "Already paid", viewController: self, type: .error, isNavigation: true)
        }
                
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        
        if ((notificationTableView.contentOffset.y + notificationTableView.frame.size.height) >= notificationTableView.contentSize.height) {
            if !isDataLoading {
                isDataLoading = true
                self.pageNo = self.pageNo + 1
                notificationsApiCall(pageNo: self.pageNo, limit: self.limit)
            }
        }
    }
}
