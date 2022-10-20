//
//  MoveToLoginViewController.swift
//  Doctoor
//
//  Created by DevBatch on 19/11/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit

class MoveToLoginViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var buttonToTap: UIButton!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    var isVersionCheck = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if isVersionCheck {
            buttonToTap.isHidden = true
            versionLabel.isHidden = false
        
        } else {
            versionLabel.isHidden = true
            buttonToTap.isHidden = false
        }
        
        view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        blurEffectView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.insertSubview(blurEffectView, at: 0)
        self.view.setNeedsDisplay()
    }
    
    @IBAction func moveToLoginButtonTapped(_ sender: Any) {
        
        if !isVersionCheck {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isTranslucent = false
        let baseViewController = BaseViewController()
        navigationController.viewControllers = [baseViewController]
        navigationController.navigationBar.isHidden = true
        UIApplication.shared.keyWindow!.replaceRootViewControllerWith(navigationController, animated: true, completion: nil)
        }
    }
}
