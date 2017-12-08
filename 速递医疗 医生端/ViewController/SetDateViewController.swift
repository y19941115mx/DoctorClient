//
//  SetDateViewController.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/8.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import Daysquare

class SetDateViewController: UIViewController {

    @IBOutlet weak var CalendarView: DAYCalendarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CalendarView.addTarget(self, action: #selector(self.CalendarChanged), for: .valueChanged)
    }

    
    @objc func CalendarChanged() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = " YYYY - MM - dd"
        let dateString = dateformatter.string(from: self.CalendarView.selectedDate)
        AlertUtil.popAlert(vc: self, msg: dateString, okhandler: {})
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
