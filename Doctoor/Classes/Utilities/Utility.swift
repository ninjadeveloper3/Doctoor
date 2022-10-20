//
//  Utility.swift
//  Doctoor
//
//  Created byDevBatch on 6/19/17.
//  Copyright © 2017DevBatch. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import BRYXBanner
import ObjectMapper
import UserNotifications
import NVActivityIndicatorView
import AudioToolbox
import AVFoundation
import SlideMenuControllerSwift
import RealmSwift
import Realm

class Utility : NSObject {
    
    static var player: AVAudioPlayer?
    static var tabController = UITabBarController()
    static var innerTabController = UITabBarController()
    
    
    class func setUpNavDrawerController() {
        
        tabController = UITabBarController()
        
        let homeViewController = HomeViewController()
        let notificationController = NotificationViewController()
        let orderViewController = OrdersViewController()
        let profileViewController = ProfileViewController()
        
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home"))
        notificationController.tabBarItem = UITabBarItem(title: "Notifications", image: #imageLiteral(resourceName: "notification"), selectedImage: #imageLiteral(resourceName: "notification"))
        orderViewController.tabBarItem = UITabBarItem(title: "My Orders", image: #imageLiteral(resourceName: "order-history"), selectedImage: #imageLiteral(resourceName: "order-history"))
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "profile"), selectedImage: #imageLiteral(resourceName: "profile"))
        
        let homeNavigationController = UINavigationController()
        homeNavigationController.navigationBar.isHidden = true
        homeNavigationController.viewControllers = [homeViewController]
        
        let notificationNavigationController = UINavigationController()
        notificationNavigationController.navigationBar.isHidden = true
        notificationNavigationController.viewControllers = [notificationController]
        
        let orderNavigationController = UINavigationController()
        orderNavigationController.navigationBar.isHidden = true
        orderNavigationController.viewControllers = [orderViewController]
        
        let profileNavigationController = UINavigationController()
        profileNavigationController.navigationBar.isHidden = true
        profileNavigationController.viewControllers = [profileViewController]
        
        tabController.viewControllers =
        [
                homeNavigationController,
                notificationNavigationController,
                orderNavigationController,
                profileNavigationController
        ]
        
        if isKeyPresentInUserDefaults(key: kToken) == false {
            tabController.tabBar.items![1].isEnabled = false
            tabController.tabBar.items![2].isEnabled = false
            tabController.tabBar.items![3].isEnabled = false
            
        } else {
            tabController.tabBar.items![1].isEnabled = true
            tabController.tabBar.items![2].isEnabled = true
            tabController.tabBar.items![3].isEnabled = true
        }

        tabController.addLeftBarButtonWithImage(#imageLiteral(resourceName: "navigation-icon"))
        tabController.selectedIndex = 0
        tabController.tabBar.tintColor = #colorLiteral(red: 0.8481271863, green: 0.1670740545, blue: 0.5549028516, alpha: 1)
        tabController.tabBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tabController.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.2632602751, green: 0.1825990379, blue: 0.4616267681, alpha: 1)
    }
    
    class func deviceUUID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    class func saveStringToUserDefaults(_ value: String?, Key: String) {
        
        if value != nil {
            UserDefaults.standard.set(value, forKey: Key)
            //UserDefaults.standard.synchronize()
        }
    }
    
    class func presentAlertOnViewController(_ title:String, message:String, viewController:UIViewController){
        
        let alertViewController = MBAlertViewController(title: title, message: message, style: .alert)
        let okAction = MBAlertAction(title: "Ok", style: .default) { (action) in
            
        }
        
        alertViewController.addAction(okAction)
        viewController.present(alertViewController, animated: true, completion: nil)
    }
    
    class func emptyTableViewMessage(imageName: String, message:String, isBannerView: Bool, viewController: UIViewController, tableView:UITableView) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewController.view.bounds.size.width, height: viewController.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.appThemeFontWithSize(15.0)
        messageLabel.sizeToFit()
        
        let noJobsView = NoJobsViews.instanceFromNib()
        noJobsView.imageView.image = UIImage(named: imageName)
        noJobsView.messageLabel.text = message
        noJobsView.messageLabel.font = UIFont.appThemeFontWithSize(15.0)
        
        tableView.backgroundView = noJobsView
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
        
        //        if isBannerView {
        //            noJobsView.b.isHidden = false
        //        } else {
        //            noJobsView.bannerView.isHidden = true
        //        }
    }
    
    class func emptyTableViewMessageWithImage(imageName: String, message: String, isBannerView: Bool, bannerText: String, viewController: UIViewController, tableView: UITableView) {
        let noJobsView = NoJobsViews.instanceFromNib()
        noJobsView.imageView.image = UIImage(named: imageName)
        noJobsView.messageLabel.text = message
        noJobsView.messageLabel.font = UIFont.appThemeFontWithSize(15.0)
        
        if isBannerView {
            noJobsView.bannerLabel.isHidden = false
            noJobsView.bannerView.isHidden = false
            noJobsView.bannerLabel.text = bannerText
            
        }
        
        tableView.backgroundView = noJobsView
        tableView.separatorStyle = .none
    }
    
    class func emptycollectionViewMessageWithImage(message:String, collectionView: UICollectionView) {
        let noJobsView = NoJobsViews.instanceFromNib()
        noJobsView.imageView.image = UIImage(named: kNoMessageImage)
        noJobsView.messageLabel.text = message
        noJobsView.messageLabel.font = UIFont.appThemeFontWithSize(15.0)
        
        collectionView.backgroundView = noJobsView
    }
    
    class func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    class func getScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    class func isiphone5() -> Bool {
        
        if self.getScreenHeight() == 568 { // Iphone 5
            
            return true
        }
        return false
    }
    
    class func isiphone6() -> Bool {
        
        if self.getScreenHeight() == 667 { // Iphone 6/7
            return true
        }
        return false
    }
    
    class func isiphone6Plus() -> Bool {
        
        if self.getScreenHeight() == 736 { // Iphone 6+/ 7+
            return true
        }
        
        return false
    }
    
    class func isiphoneX() -> Bool {
        
        switch UIScreen.main.nativeBounds.height {  // Iphone X, XS, XS Max
            
        case 2436: // iPhone X, XS
            return true
            
        case 2688: // iPhone XS Max
            return true
            
        case 1792: // iPhone XR
            return true
            
        default:
            return false
        }
    }
    
    class func saveCookies(response: DataResponse<Any>) {
        
        if let headerFields = response.response?.allHeaderFields as? [String: String] {
            let url = response.response?.url
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url!)
            var cookieArray = [[HTTPCookiePropertyKey: Any]]()
            for cookie in cookies {
                cookieArray.append(cookie.properties!)
            }
            UserDefaults.standard.set(cookieArray, forKey: kSavedCookies)
            UserDefaults.standard.synchronize()
        }
    }
    
    class func loadCookies() {
        guard let cookieArray = UserDefaults.standard.array(forKey: kSavedCookies) as? [[HTTPCookiePropertyKey: Any]] else { return }
        for cookieProperties in cookieArray {
            if let cookie = HTTPCookie(properties: cookieProperties) {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }
    }
    
    class func removedCookies() {
        UserDefaults.standard.removeObject(forKey: kSavedCookies)
        UserDefaults.standard.synchronize()
    }
    
    class func openDialerWith(number phoneNumber: String) {
        
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    class func getUserDataFromDefaults() {
        
//        if let name = UserDefaults.standard.value(forKey: kUserFirstName) as? String {
//            User.shared.firstName = name
//        }
        
        
    }
    
    class func formattedDateForMessage() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, hh:mm a"
        return dateFormatter.string(from: Date())
        
    }
    
    class func showInAppNotification(title: String, message: String, identifier: String, userInfo: [AnyHashable: Any] = [:]) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = UNNotificationSound.default
        content.userInfo = userInfo
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    class func showBanner(titile: String = "", message: String) {
        let banner = Banner(title: titile, subtitle: message, image: nil, backgroundColor: UIColor.notificationBackgroundColor())
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
    
    class func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        
        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if rootVC?.presentedViewController == nil {
            return rootVC
        }
        
        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return getVisibleViewController(presented)
        }
        return nil
    }
    
    class func showLoading(viewController: UIViewController) {
        let superView = UIView(frame: CGRect(x: self.getScreenWidth()/2 - 50, y: self.getScreenHeight()/2 - 50, width: 100, height: 100))
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: superView.frame.width/2 - 35, y: superView.frame.height/2 - 35, width: 70, height: 70))
        
        // superView.center = viewController.view.center
        superView.backgroundColor = #colorLiteral(red: 0.2632602751, green: 0.1825990379, blue: 0.4616267681, alpha: 1)
        superView.layer.cornerRadius = 10
        superView.tag = 9000
        superView.alpha = 0.85
        
        activityIndicator.type = .ballTrianglePath
        activityIndicator.color = #colorLiteral(red: 1, green: 0.1889838744, blue: 0.6510754846, alpha: 1)
        activityIndicator.startAnimating()
        
        superView.addSubview(activityIndicator)
        superView.bringSubviewToFront(activityIndicator)
        
        viewController.view.addSubview(superView)
        viewController.view.bringSubviewToFront(superView)
        viewController.view.setNeedsLayout()
        viewController.view.setNeedsDisplay()
    }
    
    class func playNewJobSound() {
        guard let url = Bundle.main.url(forResource: "labourSound", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.stop()
            guard let player = player else { return }
            
            player.play()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    class func stopNewJobSound() {
        
        if player != nil {
            player?.stop()
        }
    }
    
    class func hideLoading(viewController: UIViewController) {
        if let activityView = viewController.view.viewWithTag(9000) {
            activityView.removeFromSuperview()
        }
    }
    
    class func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    class func percentageToValue(percent: Double,amount: Double) -> Double {
        var val: Double = 0.001
        val = (percent / 100.0) * amount
        print (val)
        return amount - val
    }
    
    class func showInAppNotification(title: String, message: String, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = UNNotificationSound.default
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    class func showSuccess(viewController: UIViewController, labelText: String, completion: @escaping () -> ()) {
        let superView = UIView(frame: CGRect(x: viewController.view.frame.width/2 , y: viewController.view.frame.height/2 , width: 180, height: 150))
        let imageView = UIImageView(frame: CGRect(x: superView.frame.width/2 - 35, y: superView.frame.height/2 - 35 , width: 70, height: 70))
        
        let label = UILabel(frame: CGRect(x: 0, y: imageView.frame.height + 35 , width: 180, height: 45))
        
        label.text = labelText
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 2
        imageView.image = UIImage(named:"circle_tick")
        
        superView.center = CGPoint(x: viewController.view.bounds.width/2 , y: viewController.view.bounds.height/2)
        superView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        superView.layer.cornerRadius = 10
        superView.tag = 8000
        
        superView.addSubview(imageView)
        superView.bringSubviewToFront(imageView)
        
        superView.addSubview(label)
        superView.bringSubviewToFront(label)
        
        viewController.view.addSubview(superView)
        viewController.view.bringSubviewToFront(superView)
        
        // remove from super view after durations
        let delay = DispatchTime.now() + Double(Int64(3.0 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            
            if let activityView = viewController.view.viewWithTag(8000) {
                activityView.removeFromSuperview()
                completion()
            }
        }
    }
    
    class func configureDatabase() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 5,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 5) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        let _ = try! Realm()
    }
    
    //
    
    class func addUpdateInCart(productId: Int, quantity: Int, productType: ProductType, title: String, price: Double, description: String = "", isPrep: Int = 0) {
        
        let realm = try! Realm()
        let cartItems  = realm.objects(CartOrder.self).filter("productId = \(productId) AND productType = '\(productType.rawValue)'")
        
        if let item = cartItems.first {
            try! realm.write {
                item.quantity += quantity
            }
            
        } else {
            let cartOrder = CartOrder()
            cartOrder.id = cartOrder.incrementID()
            cartOrder.productId = productId
            cartOrder.quantity = quantity
            cartOrder.productType = productType.rawValue
            cartOrder.title = title
            cartOrder.price = price
            cartOrder.productDescription = description
            cartOrder.isPrescription = isPrep
            try! realm.write {
                realm.add(cartOrder)
            }
        }
        print(getCartItems())
    }
    
    class func incrementInCart(id: Int) {
        
        let realm = try! Realm()
        let cartItems  = realm.objects(CartOrder.self).filter("id = \(id)")
        
        if let item = cartItems.first {
            try! realm.write {
                item.quantity += 1
            }
        }
        print(getCartItems())
    }
    
    class func decrementInCart(id: Int) {
        let realm = try! Realm()
        let cartItems  = realm.objects(CartOrder.self).filter("id = \(id)")
        
        if let item = cartItems.first {
            if item.quantity <= 1 {
                try! realm.write {
                    realm.delete(item)
                }
                
            } else {
                try! realm.write {
                    item.quantity -= 1
                }
            }
        }
        print(getCartItems())
    }
    
    class func deleteInCart(id: Int) {
        let realm = try! Realm()
        let cartItems  = realm.objects(CartOrder.self).filter("id = \(id)")
        
        if let item = cartItems.first {
            try! realm.write {
                realm.delete(item)
            }
        }
        print(getCartItems())
    }
    
    class func removeInCart(productId: Int, productType: ProductType) {
        
        let realm = try! Realm()
        let cartItems  = realm.objects(CartOrder.self).filter("productId = \(productId) AND productType = '\(productType.rawValue)'")
        if let item = cartItems.first {
            if item.quantity <= 1 {
                try! realm.write {
                    realm.delete(item)
                }
                
            } else {
                try! realm.write {
                    item.quantity -= 1
                }
            }
        }
        print(getCartItems())
    }
    
    class func deleteAllItems() {
        let realm = try! Realm()
        let cartItems = realm.objects(CartOrder.self)
        
        try! realm.write {
            realm.delete(cartItems)
        }
        print(getCartItems())
    }
    
    class func getCartItems() -> [CartOrder] {
        let realm = try! Realm()
        let cartItems = realm.objects(CartOrder.self)
        return cartItems.toArray()
    }
    
    class func getProductCartItems(productId : Int, productType: ProductType) -> [CartOrder] {
        let realm = try! Realm()
        let cartItems = realm.objects(CartOrder.self).filter("productId = \(productId) AND productType = '\(productType.rawValue)'")
        return cartItems.toArray()
    }
    
    class func cartItemBadges(count : Int) {
        if count > 0 {
            
        }
    }
    
    class func attributedTitle(firstTitle: String, secondTitle: String) -> NSAttributedString {
        
        let firstAttributedTitle = [
            NSAttributedString.Key.font: UIFont.appThemeFontWithSize(20.0),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        let secondAttributedTitle = [
            NSAttributedString.Key.font: UIFont.appThemeBoldFontWithSize(20.0),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        let firstattrStr = NSMutableAttributedString(string: firstTitle, attributes: firstAttributedTitle)
        let secondAttrStr =  NSMutableAttributedString(string: secondTitle, attributes: secondAttributedTitle)
        
        firstattrStr.append(secondAttrStr)
        return firstattrStr
    }
    
    class func deleteAllUserDefaults() {
        UserDefaults.standard.removeObject(forKey: kUserSocialAvatar)
        UserDefaults.standard.removeObject(forKey: kDeviceToken)
        UserDefaults.standard.removeObject(forKey: kToken)
        UserDefaults.standard.removeObject(forKey: kShippingId)
        UserDefaults.standard.removeObject(forKey: kBillingId)
        UserDefaults.standard.set(false, forKey: kUserIsSocial)
        UserDefaults.standard.removeObject(forKey: kUserFullName)
        UserDefaults.standard.removeObject(forKey: kUserAvatar)
        UserDefaults.standard.synchronize()
    }
    
    class func dialNumber() {
        
        let number = "0518773333"
        
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
}
