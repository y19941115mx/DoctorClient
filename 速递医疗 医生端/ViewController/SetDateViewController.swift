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

class SetDateViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDate.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SetDateCollectionViewCell
        cell.updateView(data: currentDate[indexPath.row], vc:self)
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH - 20, height: 100)
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
        for item in dates {
            if res == item.doccalendarday! {
                self.currentDate.append(item)
            }
        }
        self.collectionView.reloadData()
    }
}
