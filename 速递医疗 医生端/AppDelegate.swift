//
//  AppDelegate.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/10/30.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager:AMapLocationManager = AMapLocationManager()
    var lon:String = "0"
    var lat:String = "0"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        进度条设置
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setForegroundColor(UIColor.APPColor)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setDefaultMaskType(.none) // 可点击取消
        SVProgressHUD.setDefaultAnimationType(.native) // 设置样式 圆圈的转动动作 另一个是菊花
//      高德地图设置
        self.setUpMap()
//      百度推送
        self.setUpBaiDuPush(application, didFinishLaunchingWithOptions: launchOptions)
//        环信设置
        self.setupHuanxin()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        EMClient.shared().applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        EMClient.shared().applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        BPush.registerDeviceToken(deviceToken)
        BPush.bindChannel(completeHandler: {result, error in
            if error != nil {return}
            if result != nil {
                // 获取channel_id
                let BaiDu_Channel_id = BPush.getChannelId()
                user_default.setUserDefault(key: user_default.channel_id, value: BaiDu_Channel_id)
                NetWorkUtil<BaseAPIBean>.init(method: API.updatechannelid(BaiDu_Channel_id!), vc: (self.window?.rootViewController)!).newRequest(handler: { (bean, json) in
                    Toast(bean.msg!)
                })
            }
        })
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // App 收到推送的通知
        BPush.handleNotification(userInfo)
//        _ps_Type=userInfo["psType"].intValue;//自定义type消息（和后台约定）
        let manager = userInfo["aps"] as? [String:String]
        let message = manager!["alert"]
        
        //        应用在前台或者后台，不跳转页面，让用户选择。
        if application.applicationState == .active || application.applicationState == .background{
            AlertUtil.popAlert(vc: (APPLICATION.window?.rootViewController)!, msg:message! , okhandler: {})
        }else {
            // 应用被杀死跳转页面
            let vc = ViewController()
            APPLICATION.window?.rootViewController = vc
            
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        dPrint(message: error)
    }

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    private func setUpMap() {
        AMapServices.shared().apiKey = StaticClass.GaodeAPIKey
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.locationTimeout = 2
        
        locationManager.reGeocodeTimeout = 2
        
        MapUtil.singleLocation(successHandler: {location, reGeocode in
            if reGeocode != nil {
                showToast((APPLICATION.window?.rootViewController?.view)!, "定位成功："+(reGeocode?.country)! + (reGeocode?.city)! + (reGeocode?.aoiName)!)
            }
        })
        
    }
    
    private func setUpBaiDuPush(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        if (UIDevice.current.systemVersion as NSString).floatValue >= 10.0 {
            let center =  UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.alert,.badge,.sound], completionHandler: { (granted, error) in
                if granted {
                    application.registerForRemoteNotifications()
                }
            })
        }else if (UIDevice.current.systemVersion as NSString).floatValue >= 8.0 {
            let userSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound],
                                                          categories: nil)
         UIApplication.shared.registerUserNotificationSettings(userSettings)
        }else {
            
        }

        BPush.registerChannel([:], apiKey:StaticClass.TuisongAPIKey , pushMode: BPushMode.development, withFirstAction: "打开", withSecondAction: "关闭", withCategory: "test", useBehaviorTextInput: true, isDebug: true)
        //        关闭地理推送
        BPush.disableLbs()
        
        //        初始化百度推送
        let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification]
        if userInfo != nil{
            BPush.handleNotification(userInfo as! [AnyHashable : Any])
        }
        
    }
    private func setupHuanxin() {
        let options = EMOptions.init(appkey: StaticClass.HuanxinAppkey)
        EMClient.shared().initializeSDK(with: options)
        // 环信登录
        let account = user_default.account.getStringValue()
        let pass = user_default.password.getStringValue()
        if account != nil && account != ""{
            EMClient.shared().login(withUsername: account!, password: pass, completion: { (name, error) in
                if error == nil {
                    Toast("环信登录成功")
                }else {
                    Toast("环信登录失败，\(error.debugDescription)")
                }
            })
        }
    }

}

