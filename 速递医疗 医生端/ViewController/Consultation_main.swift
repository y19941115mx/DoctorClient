//
//  Consultation_main.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Consultation_main: SegmentedSlideViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavTitle(title: "我的会诊")
        let vc1 = Consultation_page()
        vc1.flag = 1
        let vc2 = Consultation_page()
        vc2.flag = 2
        let vc3 = Consultation_page()
        vc3.flag = 3
        
        setUpSlideSwitch(titles: ["会诊申请","待确认", "进行中"], vcs: [vc1, vc2, vc3])
        // Do any additional setup after loading the view.
    }

    

}
