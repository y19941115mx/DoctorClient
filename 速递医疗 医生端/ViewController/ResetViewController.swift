//
//  ResetViewController.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/11/23.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SwiftHash
// 重置密码
class ResetViewController: BaseTextViewController {
    var LoginVc:LoginViewController!
    let MsgSeconds = 90 // 设置验证码发送间隔时间
    @IBOutlet weak var photoTextField: UITextField!
    
    @IBOutlet weak var msgCodeTextField: UITextField!
    
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var sendMsgButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
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
        initTextFieldDelegate(tv_source: [photoTextField, msgCodeTextField, password],updateBtnState: updateButtonState)
        updateButtonState()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 点击事件
    @IBAction func click_reset(_ sender: Any) {
        self.view.endEditing(true)
        // 重置密码
        let phoneText = photoTextField.text ?? ""
        let msgCode = msgCodeTextField.text ?? ""
        let passwordText = password.text ?? ""
        if passwordText.count < 6 ||  passwordText.count > 15{
            self.view.makeToast("请输入6-15位数字或字母")
        }else{
            //1.发送重置密码请求
            NetWorkUtil<BaseAPIBean>.init(method: API.editpassword(phoneText, MD5(passwordText), msgCode)).newRequest(successhandler: {bean,json  in
                // 重置成功，返回登录界面
                let vc = self.presentingViewController as! LoginViewController
                vc.tv_phone.text = phoneText
                self.dismiss(animated: false, completion: nil)
                showToast(vc.view, "重置密码成功！")
            })
                        
        }
        
    }
    
    @IBAction func click_code(_ sender: UIButton) {
        // 发送验证码
        for textField in tv_source {
            textField.resignFirstResponder()
        }
        let phoneNum = photoTextField.text!
        //开始倒计时
        isCounting = true
        //验证手机号码
        NetWorkUtil<BaseAPIBean>.init(method: .phonetest(phoneNum)).newRequest(successhandler: { bean, json in
            ToastError("手机号未注册")
        },failhandler: {bean,json  in
            if bean.code == 200 {
                // 发送手机验证码
                NetWorkUtil<BaseAPIBean>.init(method: API.getmsgcode(phoneNum)).newRequest(successhandler: {bean, json in
                    showToast(self.view, "发送验证码成功")
                })
            }else {
                showToast(self.view, bean.msg!)
            }
        })
    }
    
    //MARK: - 私有方法
    private func updateButtonState() {
        // Disable the Register button if the text field is empty.
        let phoneText = photoTextField.text ?? ""
        let msgCode = msgCodeTextField.text ?? ""
        let passwordText = password.text ?? ""
        resetButton.isEnabled = (!phoneText.isEmpty && !msgCode.isEmpty
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
