//
//  Mine_msg_main.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Mine_msg_main: BaseRefreshController<NotificationBean>,UITableViewDataSource {
    
    @IBOutlet weak var tableView: BaseTableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let titleLabel = cell.viewWithTag(1) as! UILabel
        let timeLabel = cell.viewWithTag(2) as! UILabel
        let descLabel = cell.viewWithTag(3) as! UILabel
        let bean = data[indexPath.row]
        titleLabel.text = bean.notificationtitle
        descLabel.text = bean.notificationwords
        timeLabel.text = bean.notificationcreatetime
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        
        initRefresh(scrollView: tableView, ApiMethod: .listreceivenotification(self.selectedPage), refreshHandler: nil, getMoreHandler: {
            self.getMoreMethod = .listreceivenotification(self.selectedPage)
        })
        self.header?.beginRefreshing()
        // Do any additional setup after loading the view.
    }

    @IBAction func cleanMsgAction(_ sender: Any) {
        AlertUtil.popAlert(vc: self, msg: "确认删除所有通知", okhandler: {
            NetWorkUtil.init(method: .deleteallreceivenotification).newRequest(handler: { (bean, json) in
                showToast(self.view, bean.msg!)
                self.refreshData()
            })
        })
    }
    @IBAction func BackAcion(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}

