//
//  LabReportsViewController.swift
//  Doctoor
//
//  Created by Zeeshan Haider on 25/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ObjectMapper
import PDFKit


class LabReportsViewController: UIViewController {
    
    //MARK: - Variables
    var pdfView = PDFView()
    var pdfURL: URL!
    var dataSource = [LabReports]()
    var isNotification = false
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var labReportsTableView: UITableView!
    
    //MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViewController()
    }
    
    func setUpViewController() {
        
        labReportsTableView.delegate = self
        labReportsTableView.dataSource = self
        labReportsTableView.separatorStyle = .none
        let navLabel = UILabel()
        let navTitle = Utility.attributedTitle(firstTitle: "Lab ", secondTitle: "Reports")
        navLabel.attributedText = navTitle
        navigationItem.titleView = navLabel
        doGetLabReports()
        
        if isNotification {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        }
    }
    
    func doGetLabReports(){
        Utility.showLoading(viewController: self)
        APIClient.sharedClient.getLabReports() { (response, result, error, message) in
            Utility.hideLoading(viewController: self)
            if error != nil {
                error?.showErrorBelowNavigation(viewController: self)
                
            } else {
                if let data = Mapper<LabReports>().mapArray(JSONObject: result) {
                    self.dataSource = data
                    self.labReportsTableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Private Methods
    
    
    @objc func backButtonTapped(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
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
}

extension LabReportsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reportCell = LabReportsTableViewCell.cellForTableView(tableView: tableView, atIndexPath: indexPath)
        reportCell.title.text = self.dataSource[indexPath.row].test.testName
        reportCell.subTitle.text = self.dataSource[indexPath.row].test.description
        reportCell.date.text = dateFormatter(rowDate: self.dataSource[indexPath.row].updatedAt)
        reportCell.time.text = timeFormatter(rowDate: self.dataSource[indexPath.row].updatedAt)
        reportCell.delegate = self
        return reportCell
    }
}

extension LabReportsViewController : LabReportsTableViewCellDelegate{
    func didFinishTask(cell: LabReportsTableViewCell) {
        let indexPath = self.labReportsTableView.indexPath(for: cell)
        let selectedRow = self.dataSource[indexPath?.row ?? 0]
        print("selected row",selectedRow.file)
        
        print("Complete URL", "\(kImageDownloadBaseUrl)storage/\(selectedRow.file)")
        if let url = URL(string: "\(kImageDownloadBaseUrl)storage/\(selectedRow.file)") {
            print("url", url)
            let urlSession = URLSession(configuration: .default, delegate: self as URLSessionDelegate, delegateQueue: OperationQueue())
            
            let downloadTask = urlSession.downloadTask(with: url)
            downloadTask.resume()
        }
    }
}

extension LabReportsViewController:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            self.pdfURL = destinationURL
            if((self.pdfURL) != nil){
                let pdfViewController = PDFViewerViewController()
                pdfViewController.pdfURL = self.pdfURL
                present(pdfViewController, animated: false, completion: nil)
            }
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}

