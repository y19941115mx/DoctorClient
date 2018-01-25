//
//  Mine_msg_main.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/10.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SwiftyJSON

class Mine_msg_main: BaseRefreshController<NotificationBean>,UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var ReadFlag: UIView!
    
    @IBOutlet weak var tableView: BaseTableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let titleLabel = cell.viewWithTag(1) as! UILabel
        let timeLabel = cell.viewWithTag(2) as! UILabel
        let descLabel = cell.viewWithTag(3) as! UILabel
        let readFlag = cell.viewWithTag(4) as! UIView
        let bean = data[indexPath.row]
        titleLabel.text = bean.notificationtitle
        descLabel.text = bean.notificationwords
        timeLabel.text = bean.notificationcreatetime
        if bean.notificationread! {
            readFlag.isHidden = true
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bean = data[indexPath.row]
        data[indexPath.row].notificationread = true
        tableView.reloadRows(at: [indexPath], with: .none)
        NetWorkUtil.init(method: .updatenotificationtoread(bean.notificationid!)).newRequestWithOutHUD(successhandler: { (bean, json) in
            
                UIApplication.shared.applicationIconBadgeNumber -= 1
            
        })
        // 获取数据跳转对应页面
        let notificationdata = bean.notificationdata
        if notificationdata != "{}" && notificationdata != nil  {
            if let jsonData = notificationdata!.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do {
                    let json = try JSON.init(data:jsonData)
                    if json["order_id"].int != nil {
                        // 跳转到订单详情页
                        let vc = UIStoryboard.init(name: "Date", bundle: nil).instantiateViewController(withIdentifier: "OrderDetail") as! Order_Detail
                        vc.userorderId = json["order_id"].intValue
                        self.present(vc, animated: false, completion: nil)
                    }
                    else if json["sick_id"].int != nil {
                        // 跳转到病情页
                        let vc = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Detail") as! Home_detail
                        vc.patientId = json["sick_id"].intValue
                        self.navigationController?.pushViewController(vc, animated: false)
                        self.navigationController?.setNavigationBarHidden(false, animated: false)
                    }
                }catch {
                    dPrint(message: "jsonParseError")
                }
                
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavTitle(title: "我的消息")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        initRefresh(scrollView: tableView, ApiMethod: .listreceivenotification(self.selectedPage), refreshHandler: nil, getMoreHandler: {
            self.getMoreMethod = .listreceivenotification(self.selectedPage)
        })
        self.header?.beginRefreshing()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 隐藏navigation
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    @IBAction func BackAcion(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let popoverViewController = segue.destination as? infoVc {
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.vc = self
            popoverViewController.data = self.data
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}

class infoVc:UITableViewController {
    
    var vc:Mine_msg_main!
    var data:[NotificationBean]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.readAllMsgAction()
        }else if indexPath.row == 1{
            self.cleanMsgAction()
        }
    }
    
    private func readAllMsgAction() {
        self.dismiss(animated: false, completion: nil)
        for item in data {
            item.notificationread = true
        }
        self.vc.tableView.reloadData()
        NetWorkUtil.init(method: .updateallnotificationtoread).newRequestWithOutHUD(successhandler: { (bean, json) in
            if bean.code == 100 {
                UIApplication.shared.applicationIconBadgeNumber = 0
            }else {
                ToastError(bean.msg!)
            }
        })
    }
    
    private func cleanMsgAction() {
        self.dismiss(animated: false, completion: nil)
        AlertUtil.popAlert(vc: self, msg: "确认删除所有通知", okhandler: {
            NetWorkUtil.init(method: .deleteallreceivenotification).newRequest(successhandler: { (bean, json) in
                showToast(self.view, bean.msg!)
                UIApplication.shared.applicationIconBadgeNumber = 0
                self.vc.refreshBtn()
            })
        })
    }
    
    
}

