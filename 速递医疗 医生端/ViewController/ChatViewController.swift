//
//  ChatViewController.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/2.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import EaseUI

class ChatViewController: EaseMessageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    
    func setUpNavTitle(title:String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        label.text = title
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        navigationItem.titleView = label
    }
    
}

class ConversationListViewController: EaseConversationListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        self.showRefreshHeader = true;
        //首次进入加载数据
        self.tableViewDidTriggerHeaderRefresh()
    }
    
    
    func setUpNavTitle(title:String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        label.text = title
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        navigationItem.titleView = label
    }
    
}
