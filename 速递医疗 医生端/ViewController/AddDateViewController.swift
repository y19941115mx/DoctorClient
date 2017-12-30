//
//  AddDateViewController.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/9.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import Daysquare

class AddDateViewController: BaseTableInfoViewController {
    
    @IBOutlet weak var CalendarView: DAYCalendarView!
    @IBOutlet weak var tableView: BaseTableView!
    var locMsg:[MineLocationBean]?
    var btns = [String]()
    var flag1 = false
    var flag2 = false
    
    // MARK: - UItableView
    
    func clickTable(indexPath:IndexPath) {
        switch indexPath.row {
        case 0:
            AlertUtil.popMenu(vc: self, title: "选择坐诊时间", msg: "", btns: ["上午", "下午"], handler: { (str) in
                self.flag1 = true
                self.tableInfo[indexPath.section][indexPath.row] = str
                self.tableView.reloadRows(at: [indexPath], with: .none)
            })
        case 1:
            self.btns =  [String]()
            NetWorkUtil<BaseListBean<MineLocationBean>>.init(method: .getalladdress).newRequest(handler: { (bean, json) in
                if bean.code == 100 {
                    self.locMsg = bean.dataList
                    if self.locMsg == nil {
                        showToast(self.view, "请添加坐诊地点")
                    }else {
                        
                        for item in self.locMsg! {
                            self.btns.append(item.docaddresslocation!)
                        }
                        AlertUtil.popMenu(vc: self, title: "选择坐诊地点", msg: "", btns: self.btns, handler: { (str) in
                            self.tableInfo[indexPath.section][indexPath.row] = str
                            self.tableView.reloadRows(at: [indexPath], with: .none)
                            self.flag2 = true
                        })
                    }
                }else{
                    showToast(self.view, bean.msg!)
                }
            })
            
        case 2:
            let textField = UITextField()
            textField.placeholder = "请输入简介"
            textField.keyboardType = .namePhonePad
            AlertUtil.popTextFields(vc: self, title: "输入内容", textfields: [textField], okhandler: { (textFields) in
                self.tableInfo[indexPath.section][indexPath.row] = textFields[0].text ?? ""
                self.tableView.reloadRows(at: [indexPath], with: .none)
            })
        default:
            dPrint(message: "error")
        }
        
    }
    
    
    // MARK: - view
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableData = [["请选择坐诊时间","请选择坐诊地点",""]]
        let tableTitle = [["坐诊时间", "坐诊地点", "备注"]]
        initViewController(tableTiles: tableTitle, tableInfo: tableData, tableView: tableView, clickHandler: {indexpath in
            self.clickTable(indexPath: indexpath)
        })
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func click_action(_ sender: UIButton) {
        if sender.tag == 666 {
            self.dismiss(animated: false, completion: nil)
        }else if sender.tag == 777{
            if self.CalendarView.selectedDate == nil {
                showToast(self.view, "请选择日期")
                return
            }
            if StringUTil.isEarlyThanNow(self.CalendarView.selectedDate) {
                showToast(self.view, "请选择正确的日期")
                return
            }
            if flag1 && flag2  {
                // 保存
                let locindex = btns.index(of: tableInfo[0][1])
                let locBean = locMsg![locindex!]
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = " YYYY-MM-dd"
                let dateString = dateformatter.string(from: self.CalendarView.selectedDate)
                NetWorkUtil.init(method: .addcalendar(dateString, self.tableInfo[0][0], tableInfo[0][2], locBean.docaddressid)).newRequest(handler: { (bean, json) in
                    showToast(self.view, bean.msg!)
                    if bean.code == 100 {
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            }else {
                showToast(self.view, "信息填写不完整")
            }
            
        }
    }
    
   

}
