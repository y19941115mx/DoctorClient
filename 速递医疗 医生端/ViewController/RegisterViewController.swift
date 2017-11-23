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

let MsgSeconds = 30 // 设置验证码发送间隔时间

class RegisterViewController: BaseTextViewController{
    //Mark:property
    
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
        initTextFieldDelegate(tv_source: [photoTextField, msgCodeTextField, password, password2],updateBtnState: updateBtnState)
        updateButtonState()
    }
    
    //MARK: action register
    
    @IBAction func clickRegister(_ sender: UIButton) {
        SVProgressHUD.show()
        let phoneText = photoTextField.text ?? ""
        let msgCode = msgCodeTextField.text ?? ""
        let passwordText = password.text ?? ""
        let passwordText2 = password2.text ?? ""
        if passwordText != passwordText2 {
            SVProgressHUD.dismiss()
            self.view.makeToast("两次密码输入不一致")
        }else if passwordText.count < 6 ||  passwordText.count > 15{
            self.view.makeToast("请输入6-15位数字或字母")
        }else{
            //1.发送注册请求
            let Provider = MoyaProvider<API>()
            
            Provider.request(API.docregister(phoneText, MD5(passwordText), msgCode)) { result in
                switch result {
                case let .success(response):
                    do {
                        SVProgressHUD.dismiss()
                        let bean = Mapper<BaseAPIBean>().map(JSONObject: try response.mapJSON())
                        if bean?.code == 100 {
                            // 注册成功返回登录界面
                            let vc = self.presentingViewController as! LoginViewController
                            vc.tv_phone.text = phoneText
                            self.dismiss(animated: false, completion: nil)
                        } else {
                            SVProgressHUD.dismiss()
                            self.view.makeToast((bean?.msg)!)
                        }
                    }catch {
                        SVProgressHUD.dismiss()
                        self.view.makeToast(CATCHMSG)
                    }
                case let .failure(error):
                    SVProgressHUD.dismiss()
                    dPrint(message: "error:\(error)")
                    self.view.makeToast(ERRORMSG)
                }
            }
            
        }
    }
    
    @IBAction func sendMsg(_ sender: Any) {
        for textField in tv_source {
            textField.resignFirstResponder()
        }
        let phoneNum = photoTextField.text!
        //开始倒计时
        isCounting = true
        SVProgressHUD.show()
        //验证手机号码
        let provider = MoyaProvider<API>()
        provider.request(API.phonetest(phoneNum)) { result in
            switch result {
            case let .success(response):
                do {
                    let bean = Mapper<BaseAPIBean>().map(JSONObject: try response.mapJSON())
                    if bean?.code == 100 {
                        // 发送验证码
                        let pvovider2 = MoyaProvider<API>()
                        pvovider2.request(API.getmsgcode(phoneNum)) { result in
                            switch result {
                            case let .success(response):
                                do{
                                    SVProgressHUD.dismiss()
                                    let bean2 = Mapper<BaseAPIBean>().map(JSONObject: try response.mapJSON())
                                    if bean2?.code == 100 {
                                        SVProgressHUD.dismiss()
                                        self.view.makeToast("发送验证码成功")
                                    }else {
                                        SVProgressHUD.dismiss()
                                        self.view.makeToast((bean2?.msg)!)
                                    }
                                }catch {
                                    SVProgressHUD.dismiss()
                                    self.view.makeToast(CATCHMSG)
                                }
                            case let .failure(error):
                                SVProgressHUD.dismiss()
                                dPrint(message: "error:\(error)")
                                self.view.makeToast("发送短信验证码失败")
                            }
                            
                        }
                    }else {
                        SVProgressHUD.dismiss()
                        self.view.makeToast("手机号已被注册")
                    }
                }catch {
                    SVProgressHUD.dismiss()
                    self.view.makeToast(CATCHMSG)
                }
            case let .failure(error):
                SVProgressHUD.dismiss()
                dPrint(message: "error:\(error)")
                self.view.makeToast(ERRORMSG)
            }
        }
    }
    
    //MARK: - private method
    private func updateButtonState() {
        // Disable the Register button if the text field is empty.
        let phoneText = photoTextField.text ?? ""
        let msgCode = msgCodeTextField.text ?? ""
        let passwordText = password.text ?? ""
        registerButton.isEnabled = (!phoneText.isEmpty && !msgCode.isEmpty
            && !passwordText.isEmpty)
        sendMsgButton.setBackgroundImage(ImageUtil.color2img(color: UIColor.APPGrey), for: .disabled)
        sendMsgButton.isEnabled = !phoneText.isEmpty
    }
    
    @objc private func updateTime(timer: Timer) {
        // when start counting，remainingSeconds value Decrease per second
        remainingSeconds -= 1
    }
}

