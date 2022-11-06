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


/*
 
 图像抠图：1607282610
 需求修改
 设计：宣传图和IOCN需修改，参考APP
 https://apps.apple.com/us/app/id1422471180
 ASO：主标题：Cutout cam—Photo Editor副标题：Vintage Film & Polaroid
 产品内修改【订阅逻辑】：
 抠图功能：不要给用户显示机会，导入图片后做一个3～5秒的假时间缓冲，然后弹订阅；
 拍立得功能：所有模版和文字输入功能圈免费使用，等用户保存时弹订阅，如果用户没有点订阅，第二次进来时，不给编辑机会，直接弹订阅；
 拼图功能：所有模版免费，用户点击保存时弹订阅，如果用户没有点订阅，第二次进来时，不给编辑机会，直接弹订阅；

 根据一个月定决价格判断是否是在审核期 判断货币符号是否是美国区的货币符号 然后判断现在的价格是否是1.99 如果是1.99 那就是审核状态 如果不是1.99就是非审核状态
 */


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


