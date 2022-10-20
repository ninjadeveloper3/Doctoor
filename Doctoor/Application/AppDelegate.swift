//
//  AppDelegate.swift
//  Doctoor
//
//  Created by DevBatch on 12/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Realm
import RealmSwift
import UserNotifications
import Firebase
import GoogleSignIn
import SlideMenuControllerSwift
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false,
                                     kOSSettingsKeyInAppAlerts: false,
                                     kOSSettingsKeyInAppLaunchURL: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "2f291edf-49fa-415e-9b07-ad1a2d13dfc1",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        setUpAppLibraries()
        setupAppController()
        setupPushNotification(application: application)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        UserDefaults.standard.set("\(deviceToken)", forKey: kDeviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register push notification \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
        
        print("\n Register push notification \n")
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Utility.isKeyPresentInUserDefaults(key: kToken) {
            homeViewPresentation(index: 1)
        }
    }
    
    func setupPushNotification(application: UIApplication) {
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        UIApplication.shared.applicationIconBadgeNumber = 0
        center.removeAllDeliveredNotifications()
        
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
    }
    
    func setUpAppLibraries() {
        
        Utility.configureDatabase()
        IQKeyboardManager.shared.enable = true
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
    }
    
    func setupAppController() {
        
        homeViewPresentation(index: 0)
    }
    
    func homeViewPresentation(index: Int) {
        
        Utility.setUpNavDrawerController()
        let leftMenuViewController = LeftNavDrawerViewController()
        let navController = UINavigationController()
        navController.setupAppThemeNavigationBar()
        Utility.tabController.selectedIndex = index
        navController.viewControllers = [Utility.tabController]
        let slideMenuController = SlideMenuController(mainViewController: navController, leftMenuViewController: leftMenuViewController)
        slideMenuController.modalPresentationStyle = .fullScreen
        window?.rootViewController = slideMenuController
    }
}

