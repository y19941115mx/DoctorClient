//
//  BaseTableView.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class BaseTableView: UITableView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tableFooterView = UIView()
        
    }
    //MARK: Initialization
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.tableFooterView = UIView()
        
    }
}

class BaseGropTableView: UITableView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tableFooterView = UIView()
        self.contentInset = UIEdgeInsetsMake(-35+10, 0, 0, 0)
    }
    //MARK: Initialization
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.tableFooterView = UIView()
        self.contentInset = UIEdgeInsetsMake(-35+10, 0, 0, 0)
    }
}
