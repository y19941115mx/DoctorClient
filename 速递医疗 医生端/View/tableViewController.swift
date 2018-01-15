//
//  tableViewController.swift
//  DoctorUI
//
//  Created by admin on 2017/9/15.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class MineTableViewController: UITableViewController {

    @IBOutlet weak var pocketimgView: RedPointImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(-35+8, 0, 0, 0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NetWorkUtil.init(method: .getalipayaccount).newRequestWithOutHUD { (bean, json) in
            let data = json["data"]
            let str = data["alipayaccount"].stringValue
            if str == "" {
                self.pocketimgView.isRedPoint = true
            }
        }
    }
    

}
