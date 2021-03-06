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
    lazy var vcs:[UIViewController] = {
        let vc1 = UIStoryboard.init(name: "MyPatient", bundle: nil).instantiateViewController(withIdentifier: "mypatient_check") as! Mypatient_page_check
        
        let vc2 = UIStoryboard.init(name: "MyPatient", bundle: nil).instantiateViewController(withIdentifier: "mypatient_checked") as! Mypatient_page_checked
        
        return [vc1, vc2]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置navigation
        setUpNavTitle(title: "我的病人")
        setUpSlideSwitchNoNavigation(titles: ["我选择的", "选择我的"], vcs: vcs)
    }
    
    

}

