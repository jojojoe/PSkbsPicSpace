//
//  AppDelegate.swift
//  PSkbsPicSpace
//
//  Created by mac on 2021/10/29.
//

import UIKit
import SnapKit
import SwifterSwift
import AppTrackingTransparency


public var flyerDevKey: String = ""
public var flyerAppID: String = ""


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var isForceLandscape:Bool = false
    var isForcePortrait:Bool = false
    var isForceAllDerictions:Bool = false
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .darkContent
        NotificationCenter.default.addObserver(self, selector: #selector(applicDidBecomeActiveNotifi(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        // notification
        registerNotifications(application)
        // prepare
        prepareInit()
        
        return true
    }
    
    func prepareInit() {
        // init af
        initAfLib()
        // IAP
        PurchaseManager.share.setUp()

    }

    @objc func applicDidBecomeActiveNotifi(_ notifi: Notification) {
        // Start the SDK (start the IDFA timeout set above, for iOS 14 or later)
        trackeringAuthor()
    }
    func trackeringAuthor() {
       
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: {[weak self] status in
                guard let `self` = self else {return}
            })
        } else {
            
        }
    }
    
    func initAfLib() {
        let _ = AFlyerLibManage.init(appsFlyerDevKey: flyerDevKey, appleAppID: flyerAppID)
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
         
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
         
    }


}



extension AppDelegate {
    // ????????????????????????
    func registerNotifications(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.getNotificationSettings { (setting) in
            if setting.authorizationStatus == .notDetermined {
                center.requestAuthorization(options: [.badge,.sound,.alert]) { (result, error) in
                    if (result) {
                        if !(error != nil) {
                            // ????????????
                            DispatchQueue.main.async {
                                application.registerForRemoteNotifications()
                            }
                        }
                    } else {
                        //?????????????????????
                    }
                }
            } else if (setting.authorizationStatus == .denied){
                // ????????????????????????
            } else if (setting.authorizationStatus == .authorized){
                // ??????????????????????????????dt???
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                // ????????????
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let body = notification.request.content.body
        notification.request.content.userInfo
        print(body)
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("")
        let categoryIdentifier = response.notification.request.content.categoryIdentifier
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
}


extension AppDelegate {
    /// ???????????????????????????
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if isForceAllDerictions == true {
            return .all
        } else if isForceLandscape == true {
            return .landscape
        } else if isForcePortrait == true {
            return .portrait
        }
        return .portrait
    }
    
    
}


