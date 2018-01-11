//
//  AppDelegate.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/10/30.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Bugly

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var locationManager:AMapLocationManager = AMapLocationManager()
    var lon:String = "0"
    var lat:String = "0"
    var departData = [String:[String]]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // bugly 配置
        Bugly.start(withAppId: StaticClass.BuglyAPPID)
        //        进度条设置
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setForegroundColor(UIColor.APPColor)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setDefaultMaskType(.black) // 可点击取消
        SVProgressHUD.setDefaultAnimationType(.native) // 设置样式 圆圈的转动动作 另一个是菊花
        //        获取基本数据
        self.initData()
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
                dPrint(message: BaiDu_Channel_id)
                
            }
        })
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        //        let manager = userInfo["aps"] as? [String:String]
        //        let message = manager!["alert"]
        // 清空角标
        if user_default.userId.getStringValue() == nil {
            let vc_login = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
            APPLICATION.window?.rootViewController = vc_login
        }else {
            AlertUtil.popAlert(vc: (APPLICATION.window?.rootViewController!)!, msg: "有新的消息，点击查看", okhandler: {
                let vc = UIStoryboard.init(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "mineMsg") as! Mine_msg_main
                APPLICATION.window?.rootViewController?.present(vc, animated: false, completion: nil)
            })
        }
        // App 收到推送的通知
        BPush.handleNotification(userInfo)
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        dPrint(message: error)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    private func setUpMap() {
        AMapServices.shared().apiKey = StaticClass.GaodeAPIKfey
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.locationTimeout = 2
        
        locationManager.reGeocodeTimeout = 2
        
        MapUtil.singleLocation(successHandler: {location, reGeocode in
            if reGeocode != nil {
                showToast((APPLICATION.window?.rootViewController?.view)!, "定位成功："+(reGeocode?.country)! + (reGeocode?.city)! + (reGeocode?.aoiName)!)
            }
        }, failhandler: {})
        
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
            EMClient.shared().login(withUsername: account, password: pass, completion: { (name, error) in
                if error == nil {
                    Toast("环信登录成功")
                }else {
                    dPrint(message:"环信错误码:\(error?.code.rawValue)")
                    Toast("环信登录失败")
                    //                    EMErrorCode
                }
            })
            
        }
    }
    private func initData() {
        // 获取部门数据
        NetWorkUtil.getDepartMent(success: { response in
            let json = JSON(response)
            let data = json["data"].arrayValue
            for i in 0..<data.count{
                // 处理数据
                let one = data[i]["first"].stringValue
                let two = data[i]["second"].arrayObject as! [String]
                if one != "" {
                    self.departData[one] = two
                }
            }
        }, failture:{ error in dPrint(message: error)
        })
    }
    
}

