//
//  RegisterViewController.swift
//  DoctorClient
//
//  Created by admin on 2017/8/10.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SVProgressHUD
import Moya
import ObjectMapper
import SwiftHash


class RegisterViewController: BaseTextViewController{
    //Mark:property
    let MsgSeconds = 90 // 设置验证码发送间隔时间
    var LoginVc:LoginViewController!
    @IBOutlet weak var photoTextField: UITextField!
    
    @IBOutlet weak var msgCodeTextField: UITextField!
    
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var password2: UITextField!
    
    @IBOutlet weak var sendMsgButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    var countdownTimer: Timer?
    
    var remainingSeconds = 0{
        willSet {
            sendMsgButton.setTitle("\(newValue)秒", for:.normal)
            sendMsgButton.backgroundColor = UIColor.gray
            if newValue <= 0 {
                sendMsgButton.backgroundColor = UIColor.LightSkyBlue
                sendMsgButton.setTitle("获取验证码", for: .normal)
                isCounting = false
            }
        }
        
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime(timer:)), userInfo: nil, repeats: true)
                
                remainingSeconds = MsgSeconds
                
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
            }
            
            sendMsgButton.isEnabled = !newValue
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化界面
        initTextFieldDelegate(tv_source: [photoTextField, msgCodeTextField, password, password2],updateBtnState: updateButtonState)
        updateButtonState()
    }
    
    //MARK: action register
    
    @IBAction func clickRegister(_ sender: UIButton) {
        self.view.endEditing(true)
        let phoneText = photoTextField.text ?? ""
        let msgCode = msgCodeTextField.text ?? ""
        let passwordText = password.text ?? ""
        let passwordText2 = password2.text ?? ""
        if passwordText != passwordText2 {
            SVProgressHUD.dismiss()
            self.view.makeToast("两次密码输入不一致")
        }else if StringUTil.trimmingCharactersWithWhiteSpaces(passwordText).count < 6 ||  StringUTil.trimmingCharactersWithWhiteSpaces(passwordText).count > 15{
            self.view.makeToast("请输入6-15位数字或字母")
        }else{
//            //1.发送注册请求
            NetWorkUtil.init(method: API.docregister(phoneText, MD5(passwordText), msgCode)).newRequest(successhandler: { (bean, json) in
                NavigationUtil.setRootViewController(vc: self.LoginVc)
                self.LoginVc.tv_phone.text = phoneText
                showToast(self.LoginVc.view, bean.msg!)
                
            })

        }
    }
    
    @IBAction func sendMsg(_ sender: Any) {
        self.view.endEditing(true)
        if self.photoTextField.text == "" ||  self.photoTextField.text == nil {
            showToast(self.view, "号码为空")
            return
        }
        let phoneNum = photoTextField.text!
        NetWorkUtil.init(method: .phonetest(phoneNum)).newRequest(successhandler: { (bean, json) in
            self.isCounting = true
            NetWorkUtil.init(method: API.getmsgcode(phoneNum)).newRequest(successhandler: { (bean, json) in
                showToast(self.view, "发送验证码成功")
            }, failhandler: nil)
        }, failhandler: nil)
        
    }
    
    //MARK: - private method
    private func updateButtonState() {
        // Disable the Register button if the text field is empty.
        let phoneText = photoTextField.text ?? ""
        let msgCode = msgCodeTextField.text ?? ""
        let passwordText = password.text ?? ""
        registerButton.setBackgroundImage(ImageUtil.color2img(color: UIColor.APPGrey), for: .disabled)
        registerButton.isEnabled = (!phoneText.isEmpty && !msgCode.isEmpty
            && !passwordText.isEmpty)
    }
    
    @IBAction func backAction(_ sender: Any) {
        NavigationUtil.setRootViewController(vc: self.LoginVc)
    }
    
    @objc private func updateTime(timer: Timer) {
        // when start counting，remainingSeconds value Decrease per second
        remainingSeconds -= 1
    }
}

