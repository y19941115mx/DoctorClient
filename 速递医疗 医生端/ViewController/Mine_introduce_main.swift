//
//  Mine_introduce_main.swift
//  速递医疗 医生端
//
//  Created by hongyiting on 2017/12/8.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Mine_introduce_main: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        let titleLable = cell.viewWithTag(1) as! UILabel
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.APPGrey
        return view
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.APPGrey

        // Do any additional setup after loading the view.
    }

   

}
