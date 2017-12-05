//
//  ViewController.swift
//  DoctorClient
//
//  Created by admin on 2017/8/7.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftHash



class LoginViewController: BaseTextViewController {
    
    //MARK: - property
    
    
    @IBOutlet weak var tv_phone: UITextField!
    
    @IBOutlet weak var tv_pwd: UITextField!
    
    @IBOutlet weak var btn_login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButtonState()
        // 界面设置
        initTextFieldDelegate(tv_source: [tv_pwd, tv_phone], updateBtnState: updateButtonState)
    }
    
    //MARK: - action
    @IBAction func click_login(_ sender: Any) {
        let phoneNum = tv_phone.text!
        let passNum =  tv_pwd.text!
        // FIXME:  需要做字符串长度验证
        // 登录
        NetWorkUtil<BaseAPIBean>.init(method: .doclogin(phoneNum, MD5(passNum))).newRequest { (bean, json) in
            if bean.code == 100 {
                let data = json["data"]
                let userId = data["id"].intValue
                let typename = data["typename"].stringValue
                var account = data["huanxinaccount"].stringValue
                let pix = data["pix"].stringValue
                let token = data["token"].stringValue
                let username = data["name"].stringValue
                let title = data["title"].stringValue
                user_default.setUserDefault(key: .userId, value: String(userId))
                user_default.setUserDefault(key: .typename, value: typename)
                user_default.setUserDefault(key: .pix, value: pix)
                user_default.setUserDefault(key: .token, value: token)
                user_default.setUserDefault(key: .username, value: username)
                user_default.setUserDefault(key: .title, value: title)
                user_default.setUserDefault(key: .password, value: MD5(passNum))
                // 上传channelid
                NetWorkUtil<BaseAPIBean>.init(method: API.updatechannelid(user_default.channel_id.getStringValue()!)).newRequestWithoutHUD(handler: { (bean, json) in
                    Toast(bean.msg!)
                })
                // 环信注册
                if account == "" {
                    NetWorkUtil<BaseAPIBean>.init(method: API.huanxinregister).newRequest(handler: { (bean, json) in
                        account = "doc_\(userId)"
                    })
                }
                user_default.setUserDefault(key: .account, value: account)
                
                // 环信登录
                EMClient.shared().login(withUsername: account, password: MD5(passNum), completion: { (name, error) in
                    if error == nil {
                        Toast("环信登录成功")
                    }else {
                        Toast("环信登录失败")
                    }
                })
                let vc_main = MainViewController()
                APPLICATION.window?.rootViewController = vc_main

            }else {
                showToast(self.view, bean.msg!)
            }
        }
    }
    
    //MARK: - navigation
    @IBAction func unwindToLogin (segue: UIStoryboardSegue) {
        //nothing goes here
        
    }
    
    //MARK: - private method
    private func updateButtonState() {
        // Disable the  button if the text field is empty.
        let phoneText = tv_phone.text ?? ""
        let password = tv_pwd.text ?? ""
        btn_login.setBackgroundImage(ImageUtil.color2img(color: UIColor.APPGrey), for: .disabled)
        btn_login.isEnabled = (!phoneText.isEmpty && !password.isEmpty)
        
    }
    
}

