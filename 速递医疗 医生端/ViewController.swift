//
//  ViewController.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/10/30.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 界面控制
        let userid =  user_default.username.getStringValue()
        if (userid == nil)  {
            // 跳转到登录页面
            let vc_login = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
            APPLICATION.window?.rootViewController = vc_login
        }else {
            let vc_main = MainViewController()
            APPLICATION.window?.rootViewController = vc_main
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

