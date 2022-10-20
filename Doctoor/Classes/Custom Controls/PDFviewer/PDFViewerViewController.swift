//
//  PDFViewerViewController.swift
//  Doctoor
//
//  Created by DevBatch on 21/10/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewerViewController: UIViewController {
    
    var pdfView = PDFView()
    var pdfURL: URL!
    
    @IBOutlet weak var pdfDisplayView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let document = PDFDocument(url: pdfURL) {
            pdfView.document = document
            pdfView.autoScales = true
        }
        pdfDisplayView.addSubview(pdfView)
        view.bringSubviewToFront(cancelBtn)
    }
    
    override func viewDidLayoutSubviews() {
        pdfView.frame = view.frame
    }
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
