//
//  WebViewController.swift
//  Doctoor
//
//  Created by DevBatch on 20/11/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    
    var webType : WebViewType = .termsCondition
    
    var typeUrl = ""
    
    var isNavigation = false
    
    var filterButton = UIButton()
    
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpViewController()
    }
    
    func setUpViewController() {
        let navLabel = UILabel()
        if isNavigation {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)))
        }
        
        
        var navTitle = Utility.attributedTitle(firstTitle: "Service ", secondTitle: "Conditions")
        
        typeUrl = "https://mediq.com.pk/cms/ViewCms/Conditions"
        if webType == .aboutUs {
            navTitle = Utility.attributedTitle(firstTitle: "Privacy ", secondTitle: "Policy")
            typeUrl = "https://mediq.com.pk/cms/ViewCms/Privacy"
        }
        
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
        webView.navigationDelegate = self
        if let url = URL(string: typeUrl) {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Utility.hideLoading(viewController: self)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Utility.showLoading(viewController: self)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        error.showErrorBelowNavigation(viewController: self)
        Utility.hideLoading(viewController: self)
    }

}
