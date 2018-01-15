//
//  AddDateViewController.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/9.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import FSCalendar

class AddDateViewController: BaseTableInfoViewController,FSCalendarDelegate {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: BaseTableView!
    var currentdate = [Date]()
    // 选中
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if StringUTil.isEarlyThanNow(date) {
            showToast(self.view, "请选择正确的日期")
            calendar.deselect(date)
        }else {
            currentdate.append(date)
        }
    }
    // 取消选中
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        for (index,item) in currentdate.enumerated() {
            if StringUTil.isDateEqual(date, item) {
                self.currentdate.remove(at: index)
            }
        }
    }
    
    
    var locMsg:[MineLocationBean]?
    var btns = [String]()
    var flag1 = false
    var flag2 = false
    var price:Double!
    
    // MARK: - UItableView
    
    func clickTable(indexPath:IndexPath) {
        switch indexPath.row {
        case 0:
            let priceTextField = UITextField()
            priceTextField.placeholder = "出诊价格"
            priceTextField.keyboardType = .decimalPad
            AlertUtil.popTextFields(vc: self, title: "输入出诊价格", textfields: [priceTextField]){ textFields in
                guard let price = Double(textFields[0].text!) else {
                    showToast(self.view, "价格格式出错")
                    return
                }
                self.tableInfo[0][0] = String(price)
                self.price = price
                self.flag1 = true
                self.tableView.reloadRows(at: [indexPath], with: .none)
                
            }
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
            let vc = UIStoryboard.init(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "addDate") as! AddTimeViewController
            vc.timeType = .上午
            self.present(vc, animated: false, completion: nil)
        case 3:
            let vc = UIStoryboard.init(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "addDate") as! AddTimeViewController
            vc.timeType = .下午
            self.present(vc, animated: false, completion: nil)
        case 4:
            let vc = UIStoryboard.init(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "addDate") as! AddTimeViewController
            vc.timeType = .晚上
            self.present(vc, animated: false, completion: nil)
            
        default:
            let textField = UITextField()
            textField.placeholder = "请输入简介"
            textField.keyboardType = .namePhonePad
            AlertUtil.popTextFields(vc: self, title: "输入内容", textfields: [textField], okhandler: { (textFields) in
                self.tableInfo[indexPath.section][indexPath.row] = textFields[0].text ?? ""
                self.tableView.reloadRows(at: [indexPath], with: .none)
            })
        }
        
    }
    
    // MARK: - view
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableData = [["0.0","请选择坐诊地点","","","",""]]
        let tableTitle = [["设置出诊价格", "坐诊地点","上午","下午","晚上", "备注"]]
        initViewController(tableTiles: tableTitle, tableInfo: tableData, tableView: tableView, clickHandler: {indexpath in
            self.clickTable(indexPath: indexpath)
        })
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func click_action(_ sender: UIButton) {
        if sender.tag == 666 {
            self.dismiss(animated: false, completion: nil)
        }else if sender.tag == 777{
            if self.currentdate.count == 0 {
                showToast(self.view, "请选择日期")
                return
            }
            if flag1 && flag2  {
                // 保存
                let locindex = btns.index(of: tableInfo[0][1])
                let locBean = locMsg![locindex!]
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = " YYYY-MM-dd"
                // 时间字符数组
                var dateArr = [String]()
                for item in self.currentdate {
                    let dateString = dateformatter.string(from: item)
                    dateArr.append(dateString)
                }
                let dateStr = Array<String>.ArraytoString(array: dateArr, separator: ",")
                NetWorkUtil.init(method: .addcalendar(dateStr, self.price, tableInfo[0][5], locBean.docaddressid, tableInfo[0][2], tableInfo[0][3], tableInfo[0][4])).newRequest(handler: { (bean, json) in
                    if bean.code == 100 {
                        self.dismiss(animated: false, completion: nil)
                    }else {
                        showToast(self.view, bean.msg!)
                    }
                })
            }else {
                showToast(self.view, "信息填写不完整")
            }
            
        }
    }
}


import PGDatePicker

enum TimeType:String {
    case 上午, 下午, 晚上
}

class AddTimeViewController: BaseTableInfoViewController,PGDatePickerDelegate {
    
    func datePicker(_ datePicker: PGDatePicker!, didSelectDate dateComponents: DateComponents!) {
        let calendar = Calendar.current
        let newDate = calendar.date(from: dateComponents)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if datePicker.tag == 0 {
            self.beginComponents = dateComponents
            beginDate = newDate!
            beginTime = StringUTil.DateToString(newDate!, formatter)
            tableInfo[0][0] = beginTime!
        }else {
            endTime = StringUTil.DateToString(newDate!, formatter)
            if let beginDate = self.beginDate {
                if StringUTil.isDateLater(newDate!, beginDate)
                {
                    self.flag = true
                    if dateComponents.hour == self.beginComponents.hour && dateComponents.minute == self.beginComponents.minute {
                        self.flag = false
                    }
                }else {
                    showToast(self.view, "结束时间应该在开始时间之后")
                }
                tableInfo[1][0] = endTime!
            }else {
               showToast(self.view, "请选择开始时间")
            }
        }
        self.tableView.reloadData()
        
    }
    
    
    @IBOutlet weak var tableView: BaseTableView!
    
    var beginTime:String?
    var beginDate:Date?
    var beginComponents:DateComponents!
    var endTime:String?
    var timeType:TimeType = .上午
    var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = [["选择起始时间"],["选择结束时间"]]
        let info = [[""],[""]]
        setUpNavTitle(title: "选择时间段")
        initViewController(tableTiles: title, tableInfo: info, tableView: tableView, clickHandler: {indexpath in
            self.handleclick(indexPath: indexpath)
        })
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if flag {
            performSegue(withIdentifier: "addDate", sender: self)
        }else {
            showToast(self.view, "请正确填写时间段")
        }
    }
    
    
    private func handleclick(indexPath:IndexPath) {
        let datePickerManager = PGDatePickManager()
        let datePicker = datePickerManager.datePicker!
        datePicker.tag = indexPath.section
        datePicker.delegate = self
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "zh_CN")
        switch self.timeType {
        case .上午:
            datePicker.maximumDate = NSDate.setHour(11, minute: 59)
            datePicker.minimumDate = NSDate.setHour(7, minute: 0)
        case .下午:
            datePicker.maximumDate = NSDate.setHour(18, minute: 0)
            datePicker.minimumDate = NSDate.setHour(12, minute: 0)
        default:
            datePicker.maximumDate = NSDate.setHour(22, minute: 0)
            datePicker.minimumDate = NSDate.setHour(19, minute: 0)
        }
        self.present(datePickerManager, animated: false, completion: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addDate" {
            let vc = self.presentingViewController as! AddDateViewController
            switch self.timeType {
            case .上午:
                vc.tableInfo[0][2] = "\(beginTime!)-\(endTime!)"
            case .下午:
                vc.tableInfo[0][3] =  "\(beginTime!)-\(endTime!)"
            default:
                vc.tableInfo[0][4] = "\(beginTime!)-\(endTime!)"
            }
            vc.tableView.reloadData()
            self.dismiss(animated: false, completion: nil)
        }
    }
    
}
