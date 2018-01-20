//
//  Consultation_confirmOrder.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Consultation_confirmOrder: BaseTableInfoViewController {
    
    @IBOutlet weak var tableView: BaseGropTableView!
    // 传进来的订单id
    var orderId:Int?
    // 传进来的refreashController
    var vc:BaseRefreshController<ConsultationBean>?
    let textField = UITextField()
    var trafficType:Int = 1
    var hotelType:Int = 1
    var foodType:Int = 1
    
    var flag:Int?
    
    @IBOutlet weak var saveBtn: UIButton!
    let popTitle = ["自理", "医院方付", "病人支付"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.keyboardType = .decimalPad
        let titiles = [["出诊价格"],["交通类型", "交通价格"],["住宿类型", "住宿价格"],["餐饮类型", "餐饮价格"]]
        let info = [["0.0"],["自理", "0.0"],["自理", "0.0"],["自理", "0.0"]]
        self.initViewController(tableTiles: titiles, tableInfo: info, tableView: self.tableView) { (indexPath) in
            self.handleCheck(indexPath: indexPath)
        }
        if flag != nil {
            saveBtn.isHidden = true
            self.tableView.allowsSelection = false
            NetWorkUtil<BaseBean<ConsultationBean>>.init(method: API.getconsultationdetail(self.orderId!)).newRequest(successhandler: { (bean, json) in
                if bean.code == 100 && bean.data != nil {
                    let res = bean.data!
                    self.tableInfo = [["\(res.orderhospprice!)"],["\(res.orderhosptpricetypename!)", "\(res.orderhosptprice!)"],["\(res.orderhospapricetypename!)", "\(res.orderhospaprice!)"],["\(res.orderhospepricetypename!)", "\(res.orderhospeprice!)"]]
                    self.tableView.reloadData()
                }
                
            })
            
        }
        
    }
    
    
    @IBAction func click_save(_ sender: UIButton) {
        if self.tableInfo[0][0] == "0.0" {
            showToast(self.view, "出诊价格不能为0")
        }else {
            AlertUtil.popAlert(vc: self, msg: "确认提交订单，操作不可撤销", okhandler: {
                NetWorkUtil.init(method: .confirmconsultation(self.orderId!, Double(self.tableInfo[0][0])!, self.trafficType, Double(self.tableInfo[1][1])!, self.hotelType, Double(self.tableInfo[2][1])!, self.foodType, Double(self.tableInfo[3][1])!)).newRequest(successhandler: { (bean, json) in
                    
                    self.dismiss(animated: false, completion: nil)
                    self.vc?.header?.beginRefreshing()
                    
                    
                })
            })
        }
    }
    
    @IBAction func click_back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // 处理点击table
    private func handleCheck(indexPath:IndexPath) {
        switch indexPath.section {
        case 0:
            // 出诊价格
            textField.placeholder = "输入出诊价格"
            AlertUtil.popTextFields(vc: self, title: "输入内容", textfields: [textField], okhandler: { (textFields) in
                let text = textFields[0].text ?? "0.0"
                self.tableInfo[indexPath.section][indexPath.row] = text
                self.tableView.reloadRows(at: [indexPath], with: .none)
            })
        case 1:
            switch indexPath.row {
            case 0:
                // 交通类型
                AlertUtil.popMenu(vc: self, title: "选择交通类型", msg: "", btns: self.popTitle, handler: { (str) in
                    let index = self.popTitle.index(of: str)
                    self.trafficType = index! + 1
                    self.tableInfo[indexPath.section][indexPath.row] = str
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                })
            default:
                // 交通价格
                textField.placeholder = "输入交通价格"
                AlertUtil.popTextFields(vc: self, title: "输入内容", textfields: [textField], okhandler: { (textFields) in
                    let text = textFields[0].text ?? "0.0"
                    self.tableInfo[indexPath.section][indexPath.row] = text
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                })
            }
        case 2:
            switch indexPath.row {
            case 0:
                // 住宿类型
                AlertUtil.popMenu(vc: self, title: "选择住宿类型", msg: "", btns: self.popTitle, handler: { (str) in
                    let index = self.popTitle.index(of: str)
                    self.hotelType = index! + 1
                    self.tableInfo[indexPath.section][indexPath.row] = str
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                })
            default:
                // 住宿价格
                textField.placeholder = "输入住宿价格"
                AlertUtil.popTextFields(vc: self, title: "输入内容", textfields: [textField], okhandler: { (textFields) in
                    let text = textFields[0].text ?? "0.0"
                    self.tableInfo[indexPath.section][indexPath.row] = text
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                })
            }
        default:
            switch indexPath.row {
            case 0:
                // 餐饮类型
                AlertUtil.popMenu(vc: self, title: "选择餐饮类型", msg: "", btns: self.popTitle, handler: { (str) in
                    let index = self.popTitle.index(of: str)
                    self.foodType = index! + 1
                    self.tableInfo[indexPath.section][indexPath.row] = str
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                })
            default:
                // 餐饮价格
                textField.placeholder = "输入餐饮价格"
                AlertUtil.popTextFields(vc: self, title: "输入内容", textfields: [textField], okhandler: { (textFields) in
                    let text = textFields[0].text ?? "0.0"
                    self.tableInfo[indexPath.section][indexPath.row] = text
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                })
            }
        }
        
    }
    
}
