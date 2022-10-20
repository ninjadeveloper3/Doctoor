//
//  MyPrescriptionsViewController.swift
//  Doctoor
//
//  Created by Moiz Amjad on 09/04/2020.
//  Copyright © 2020 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper

class MyPrescriptionsViewController: UIViewController {
    
    var dataSource = [Prescription]()
    
    var imagesDirectoryPath:String!
    var images:[UIImage]!
    var titles:[String]!
    var ImageURL : URL!
    
    @IBOutlet weak var prescpListView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViewController()
    }
    
    func setUpViewController() {
        
        prescpListView.delegate = self
        prescpListView.dataSource = self
        prescpListView.separatorStyle = .none
        
        
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "Prescription ", secondTitle: "List")
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
        doGetLabReports()
//
//        if isNotification {
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
//        }
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    func doGetLabReports(){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getPrescriptionList() { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<Prescription>().mapArray(JSONObject: result) {
                    self.dataSource = data
                    self.prescpListView.reloadData()
                }
            }
        }
    }
    func dateFormatter(rowDate: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM,yyyy"
        
        var formatedDate = ""
        
        if let date = dateFormatterGet.date(from: rowDate) {
            print(dateFormatterPrint.string(from: date))
            formatedDate = dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string")
        }
        return formatedDate
    }
    
    func timeFormatter(rowDate: String) -> String {
        let timeFormatterGet = DateFormatter()
        timeFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let timeFormatterPrint = DateFormatter()
        timeFormatterPrint.dateFormat = "HH:mm"
        
        var formatedTime = ""
        
        if let time = timeFormatterGet.date(from: rowDate) {
            print(timeFormatterPrint.string(from: time))
            formatedTime = timeFormatterPrint.string(from: time)
        } else {
            print("There was an error decoding the string")
        }
        return formatedTime
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            Utility.hideLoading(viewController: self)
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            Utility.hideLoading(viewController: self)
            let ac = UIAlertController(title: "Saved!", message: "Your Prescription image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}
extension MyPrescriptionsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prescriptionCell = MyPrescptionsTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        prescriptionCell.namePrescription.text = self.dataSource[indexPath.row].name
        prescriptionCell.createdDate.text = dateFormatter(rowDate: self.dataSource[indexPath.row].createdAt)
        prescriptionCell.createdTime.text = timeFormatter(rowDate: self.dataSource[indexPath.row].createdAt)
        prescriptionCell.delegate = self
        return prescriptionCell
    }
}

extension MyPrescriptionsViewController : MyPrescptionsTableViewCellDelegate{
    func didFinishTask(cell: MyPrescptionsTableViewCell) {
        let indexPath = self.prescpListView.indexPath(for: cell)
                let selectedRow = self.dataSource[indexPath?.row ?? 0]
                Utility.showLoading(viewController: self)
                print("selected row",selectedRow.name)
        
                if let url = URL(string: "\(kPrescriptionImageDownloadBaseUrl)storage/\(selectedRow.path)") {
                    print("url", url)
                    
                    
                    
                    if let url = URL(string: "\(kPrescriptionImageDownloadBaseUrl)storage/\(selectedRow.path)"),
                        let data = try? Data(contentsOf: url),
                        let image = UIImage(data: data) {
                        
                        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

                    }
                }
    }
}
