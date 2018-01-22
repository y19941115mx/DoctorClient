//
//  SetDateViewController.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/8.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SnapKit
import FSCalendar
import PGDatePicker

class SetDateViewController: BaseViewController, UITableViewDelegate,UITableViewDataSource,FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet weak var tableVIew: BaseTableView!
    var tableTitle = ""
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = currentDate[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        let timelabel = cell.viewWithTag(1) as! UILabel
        let interLabel = cell.viewWithTag(2) as! UILabel
        let descLabel = cell.viewWithTag(4) as! UILabel
        let localLabel = cell.viewWithTag(3) as! UILabel
        let priceLabel = cell.viewWithTag(5) as! UILabel
        descLabel.text = data.doccalendaraffair
        timelabel.text = data.doccalendartime
        interLabel.text = data.doccalendartimeinterval
        localLabel.text =  data.docaddresslocation
        priceLabel.text = "\(data.doccalendarprice)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bean = currentDate[indexPath.row]
        let vc = EditDateViewController()
        vc.bean = bean
        let nvc = UINavigationController.init(rootViewController: vc)
        self.present(nvc, animated: false, completion: nil)
    }
    
    
    
    @IBOutlet weak var calendar: FSCalendar!
    
    var dates = [MineCalendarBean]()
    var currentDate = [MineCalendarBean]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupCalendar()
    }
    
    @IBAction func ButtonAcion(_ sender: UIButton) {
        if sender.tag == 666 {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    //MARK: - 日历相关
    
    private func setupCalendar() {
        let res = StringUTil.DateToComponents(calendar.currentPage)
        NetWorkUtil<BaseListBean<MineCalendarBean>>.init(method: .getcalendarbymonth(res.year!, res.month!)).newRequest(successhandler: { (bean, json) in
            
            if let list = bean.dataList {
                self.dates = list
                self.calendar.reloadData()
            }
            
        })
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.setupCalendar()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let dateStr = StringUTil.DateToString(date, formatter)
        for item in dates {
            if dateStr == item.doccalendarday {
                return 1
            }
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.currentDate.removeAll()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let res = StringUTil.DateToString(date, formatter)
        formatter.dateFormat = "YYYY年MM月dd日"
        self.tableTitle = StringUTil.DateToString(date, formatter)
        for item in dates {
            if res == item.doccalendarday{
                self.currentDate.append(item)
            }
        }
        self.tableVIew.reloadData()
    }
}





class EditDateViewController:BaseTableInfoViewController, PGDatePickerDelegate {
    var bean:MineCalendarBean!
    let tableView = UITableView()
    var locMsg:[MineLocationBean]?
    var btns = [String]()
    var price = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化界面
        self.setupView()
        setUpNavTitle(title: "编辑日程")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "确定", style: .plain, target: self, action: #selector(clickSave))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(clickBack))
    }
    
    private func setupView() {
        let tableTitle = [["坐诊价格", "坐诊地点","时间段", "备注"]]
        let tableData = [["\(bean.doccalendarprice)",bean.docaddresslocation,bean.doccalendartimeinterval,bean.doccalendaraffair]]
        self.view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        initViewController(tableTiles: tableTitle, tableInfo: tableData, tableView: tableView, clickHandler: {indexpath in
            self.clickTable(indexPath: indexpath)
        })
    }
    // 选择时间
    func datePicker(_ datePicker: PGDatePicker!, didSelectDate dateComponents: DateComponents!) {
        let calendar = Calendar.current
        let newDate = calendar.date(from: dateComponents)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let beginTime = StringUTil.DateToString(newDate!, formatter)
        self.tableInfo[0][2] = beginTime
        self.tableView.reloadData()
    }
    
   private func clickTable(indexPath:IndexPath) {
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
                self.price = price
                self.tableInfo[0][0] = String(price)
                self.tableView.reloadRows(at: [indexPath], with: .none)
                
            }
        case 1:
            NetWorkUtil<BaseListBean<MineLocationBean>>.init(method: .getalladdress).newRequest(successhandler: { (bean, json) in
                
                self.locMsg = bean.dataList
                if self.locMsg == nil {
                    showToast(self.view, "请添加坐诊地点")
                }else {
                    
                    for item in self.locMsg! {
                        self.btns.append(item.docaddresslocation!)
                    }
                    AlertUtil.popOptional(optional: self.btns, handler: { (str) in
                        self.tableInfo[indexPath.section][indexPath.row] = str
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                    })
                }
                
            })
            
        case 2:
            //选择时间段
            let datePickerManager = PGDatePickManager()
            let datePicker = datePickerManager.datePicker!
            datePicker.tag = indexPath.section
            datePicker.delegate = self
            datePicker.datePickerMode = .time
            datePicker.locale = Locale(identifier: "zh_CN")
            self.present(datePickerManager, animated: false, completion: nil)
        default:
            let textField = UITextField()
            textField.placeholder = "请输入备注"
            textField.keyboardType = .namePhonePad
            AlertUtil.popTextFields(vc: self, title: "输入内容", textfields: [textField], okhandler: { (textFields) in
                self.tableInfo[indexPath.section][indexPath.row] = textFields[0].text!
                self.tableView.reloadRows(at: [indexPath], with: .none)
            })
        }
        
    }
    
    @objc func clickSave() {
        var addressId = self.bean.doccalendaradressid
        if btns.count != 0 {
            let locindex = btns.index(of: tableInfo[0][1])
            let locBean = locMsg![locindex!]
            addressId = locBean.docaddressid
        }
        NetWorkUtil.init(method: .editcalendar(self.bean.doccalendarid, addressId, price, self.bean.doccalendarday, tableInfo[0][2], tableInfo[0][3])).newRequest(successhandler: {bean, json in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    @objc func clickBack() {
        self.dismiss(animated: false, completion: nil)
    }
}
