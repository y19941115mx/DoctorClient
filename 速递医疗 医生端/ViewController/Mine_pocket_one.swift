//
//  Mine_pocket_one.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Mine_pocket_one: BaseTableInfoViewController {
    
    @IBOutlet weak var tableView: BaseTableView!
    @IBOutlet weak var balance: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titles = [["绑定支付宝"],["交易记录"]]
        let infos = [["未绑定"],[""]]
        initViewController(tableTiles: titles, tableInfo: infos, tableView: tableView) { (indexpath) in
            self.handleClick(indexPath: indexpath)
        }
        self.getdata()
        
        // Do any additional setup after loading the view.
    }
    
    private func handleClick(indexPath:IndexPath) {
        if indexPath.section == 0 {
            // 绑定支付宝
            let textField = UITextField()
            textField.placeholder = "输入支付宝账号"
            let textField2 = UITextField()
            textField2.placeholder = "输入支付宝认证的姓名"
            // 绑定支付宝
            AlertUtil.popTextFields(vc: self, title: "输入支付宝信息", textfields: [textField, textField2], okhandler: { (textFields) in
                let account = textFields[0].text ?? ""
                let name = textFields[1].text ?? ""
                if account == "" || name == "" {
                    showToast(self.view, "账号或姓名为空")
                }else {
                    NetWorkUtil.init(method: API.updatealipayaccount(account, name)).newRequest(successhandler: { (bean, json) in
                        showToast(self.view, bean.msg!)
                        self.tableInfo[0][0] = account
                        self.flags = [[false],[false]]
                        self.tableView.reloadData()
                    })
                }
                
            })
        }else {
            // 交易记录
            performSegue(withIdentifier: "交易记录", sender: self)
        }
        
    }
    
    private func getdata() {
        NetWorkUtil.init(method: .getbalance).newRequest(successhandler:{ (bean, json) in
            
            let data = json["data"].doubleValue
            self.balance.text = String(data)
        })
        NetWorkUtil.init(method: .getalipayaccount).newRequestWithOutHUD(successhandler: { (bean, json) in
            let data = json["data"]
            let str = data["alipayaccount"].stringValue
            if str != "" {
                self.tableInfo[0][0] = str
                self.tableView.reloadData()
            }else {
                self.flags = [[true],[false]]
            }
        })
    }
    
    @IBAction func unwindToMinePocket(sender: UIStoryboardSegue){
        
    }
    
}
