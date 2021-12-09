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
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var isForceLandscape:Bool = false
    var isForcePortrait:Bool = false
    var isForceAllDerictions:Bool = false
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(applicDidBecomeActiveNotifi(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        registerNotifications(application)
        
          
        return true
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
        }
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
         
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
         
    }


}



extension AppDelegate {
    // 注册远程推送通知
    func registerNotifications(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.getNotificationSettings { (setting) in
            if setting.authorizationStatus == .notDetermined {
                center.requestAuthorization(options: [.badge,.sound,.alert]) { (result, error) in
                    if (result) {
                        if !(error != nil) {
                            // 注册成功
                            DispatchQueue.main.async {
                                application.registerForRemoteNotifications()
                            }
                        }
                    } else {
                        //用户不允许推送
                    }
                }
            } else if (setting.authorizationStatus == .denied){
                // 申请用户权限被拒
            } else if (setting.authorizationStatus == .authorized){
                // 用户已授权（再次获取dt）
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                // 未知错误
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
    /// 设置屏幕支持的方向
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


