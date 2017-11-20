//
//  tableViewController.swift
//  DoctorUI
//
//  Created by admin on 2017/9/15.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class tableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.sectionHeaderHeight = 0
//        self.tableView.sectionFooterHeight = 0
        self.tableView.contentInset = UIEdgeInsetsMake(-35+8, 0, 0, 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
