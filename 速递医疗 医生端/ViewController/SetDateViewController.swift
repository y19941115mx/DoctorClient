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
        descLabel.text = data.doccalendaraffair ?? ""
        timelabel.text = data.doccalendartime ?? ""
        interLabel.text = data.doccalendartimeinterval ?? ""
        localLabel.text =  data.docaddresslocation ?? ""
        return cell
    }
    
    
    
    @IBOutlet weak var calendar: FSCalendar!
    
    var dates = [MineCalendarBean]()
    var currentDate = [MineCalendarBean]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCalendar()
        // Do any additional setup after loading the view.
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
            if dateStr == item.doccalendarday! {
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
            if res == item.doccalendarday! {
                self.currentDate.append(item)
            }
        }
        self.tableVIew.reloadData()
    }
}
