//
//  Date_main.swift
//  速递医疗 医生端
//
//  Created by hongyiting on 2017/12/5.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Date_main: SegmentedSlideViewController {
    private let types = ["待病人确认", "进行中"]
    private var vcs = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置navigation
        setUpNavTitle(title: "我的日程")
        
        let vc1 = Date_page()
        vc1.flag = 1
        
        let vc2 = Date_page()
        vc2.flag = 2
        
        vcs = [vc1, vc2]
        
        setUpSlideSwitch(titles:types, vcs:vcs)
    }
}
