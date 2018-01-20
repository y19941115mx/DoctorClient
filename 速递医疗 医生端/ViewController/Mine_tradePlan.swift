//
//  Mine_tradePlan.swift
//  速递医疗 医生端
//
//  Created by hongyiting on 2018/1/14.
//  Copyright © 2018年 victor. All rights reserved.
//

import UIKit

class Mine_tradePlan: BaseTableInfoViewController {
    
    @IBOutlet weak var infoTableView: BaseGropTableView!
    let textField = UITextField()
    
    
    var infos = [MineLocationBean]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titles = [["出诊计划","默认出诊价格"],["默认出诊地点","常用地址"]]
        let tableinfos = [["编辑出诊计划", "0.00"],["选择出诊地点",""]]
        initViewController(tableTiles: titles, tableInfo: tableinfos, tableView: infoTableView) { (indexPath) in
            self.clickHandler(indexpath: indexPath)
        }
        self.getInfo()
        
    }
    // 点击事件
    private func clickHandler(indexpath:IndexPath) {
        switch indexpath.section {
        case 0:
            if indexpath.row == 0 {
                //出诊计划
                performSegue(withIdentifier: "SetDate", sender: self)
            }else {
                // 出诊价格
                self.textField.placeholder = "请输入出诊价格"
                self.textField.keyboardType = .decimalPad
                AlertUtil.popTextFields(vc: self, title: "输入信息", textfields: [self.textField], okhandler: { (textfields) in
                    let text = textfields[0].text ?? ""
                    if text != "" {
                        let price = Double(text)
                        if price == nil {
                            showToast(self.view, "价格格式错误")
                            return
                        }
                        NetWorkUtil.init(method: API.updateprice(price!)).newRequest(successhandler: { (bean, json) in
                            
                            self.tableInfo[0][1] = text
                            self.infoTableView.reloadRows(at: [indexpath], with: .none)
                        })
                    }
                })
            }
        default:
            if indexpath.row == 0 {
                // 出诊地点
                var btns = [String]()
                for item in infos {
                    btns.append(item.docaddresslocation!)
                }
                AlertUtil.popMenu(vc: self, title: "设置默认出诊地点", msg: "", btns: btns, handler: { (str) in
                    let index = btns.index(of: str)
                    let addressidid = self.infos[index!].docaddressid
                    NetWorkUtil.init(method: API.setaddress(addressidid)).newRequest(successhandler: { (bean, josn) in
                            // 改变table
                            self.tableInfo[1][0] = str
                            self.infoTableView.reloadData()
                    })
                })
            }else {
                // 常用地址
                performSegue(withIdentifier: "AddHospital", sender: self)
            }
        }
    }
    
    private func getInfo() {
        // 获取地点
        NetWorkUtil<BaseListBean<MineLocationBean>>.init(method: .getalladdress)
            .newRequestWithOutHUD(successhandler: { (bean, json) in
                let datas = bean.dataList
                if datas != nil {
                    for data in datas! {
                        if data.docaddresschecked {
                            self.tableInfo[1][0] = data.docaddresslocation!
                            self.infoTableView.reloadData()
                        }
                        self.infos.append(data)
                    }
                }
        })
        // 获取价格
        NetWorkUtil.init(method: .getprice).newRequestWithOutHUD(successhandler:{ (bean, json) in
            let price = json["data"].doubleValue
            self.tableInfo[0][1] = String(price)
            self.infoTableView.reloadData()
        })
    }
    
    
    
}
