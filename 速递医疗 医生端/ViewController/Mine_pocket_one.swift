//
//  Mine_pocket_one.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Mine_pocket_one: UIViewController {
    
    @IBOutlet weak var balance: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NetWorkUtil.init(method: .getbalance).newRequest { (bean, json) in
            if bean.code == 100 {
                let data = json["data"].doubleValue
                self.balance.text = String(data)
            }
            showToast(self.view, bean.msg!)
            
        }
    }

}
