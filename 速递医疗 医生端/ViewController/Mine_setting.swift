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
        let titles = [["退出登录"]]
        let infos:[[String]] = [[""], ["", ""], [""]]
        initViewController(tableTiles: titles, tableInfo: infos, tableView: tableView) { (indexpath) in
            self.handler(indexPath: indexpath)
        }
        
    }
    
    private func handler(indexPath:IndexPath) {
            user_default.logout("")
    }
    
    
}
