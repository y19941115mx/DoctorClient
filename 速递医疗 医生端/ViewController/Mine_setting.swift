//
//  Mine_setting.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/11/21.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Mine_setting: BaseViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let label1 = cell.viewWithTag(1) as! UILabel
        let label2 = cell.viewWithTag(2) as! UILabel
        label1.text = "退出登录"
        label2.text = "点击回到登录界面"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            logout()
        default:
            dPrint(message: "error")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    
    private func logout() {
        user_default.clearUserDefault()
        NetWorkUtil<BaseAPIBean>.init(method: .exit, vc: self).newRequest(handler: {bean in
            if bean.code == 100 {
                let vc_login = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
                APPLICATION.window?.rootViewController = vc_login
            }else {
                showToast(self.view, bean.msg!)
            }
            
        })
    }
    
}
