//
//  Mine_setting.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/11/21.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Mine_setting: BaseTableInfoViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        let titles = [["绑定支付宝"],["意见反馈", "关于我们"], ["退出登录"]]
        let infos:[[String]] = [[""], ["", ""], [""]]
        initViewController(tableTiles: titles, tableInfo: infos, tableView: tableView) { (indexpath) in
            self.handler(indexPath: indexpath)
        }
        
    }
    private func handler(indexPath:IndexPath) {
        switch indexPath.section {
        case 0:
            let textField = UITextField()
            textField.placeholder = "输入支付宝账号"
            // 绑定支付宝
            AlertUtil.popTextFields(vc: self, title: "输入支付宝账号", textfields: [textField], okhandler: { (textFields) in
                let account = textFields[0].text ?? ""
                if account == "" {
                    showToast(self.view, "请填写账号")
                }else {
                    NetWorkUtil.init(method: API.updatealipayaccount(account)).newRequest(handler: { (bean, json) in
                        showToast(self.view, bean.msg!)
                    })
                }
                
            })
        case 1:
            showToast(self.view, "功能完善中")
        default:
            // 退出登录
            logout()
        }
    }
    
    private func logout() {
        NetWorkUtil<BaseAPIBean>.init(method: .exit).newRequest(handler: {bean,json  in
            if bean.code == 100 {
                user_default.clearUserDefault()
                let vc_login = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
                EMClient.shared().logout(false, completion: { (error)
                    in
                    if error == nil {
                        Toast("环信退出成功")
                    }else {
                        Toast("环信退出失败")
                    }
                })
                APPLICATION.window?.rootViewController = vc_login
            }else {
                showToast(self.view, bean.msg!)
            }
            
        })
    }
    
}
