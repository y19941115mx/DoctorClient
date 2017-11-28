//
//  Date_main.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/4.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Mypatient_main: SegmentedSlideViewController {

    private let types = ["我选择的", "选择我的"]
    private var vcs = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置navigation
        setUpNavTitle(title: "我的病人")
        // 设置分栏
//        let vc1 = UIStoryboard.init(name: "Date", bundle: nil).instantiateViewController(withIdentifier: "order") as! Date_page
//        vc1.type = 1
//        let vc2 = UIStoryboard.init(name: "Date", bundle: nil).instantiateViewController(withIdentifier: "order") as! Date_page
//        vc2.type = 2
        
//        vcs = [vc1, vc2]

        setUpSlideSwitch(titles: types, vcs: vcs)
    }

}

