//
//  MypatientConfirmOrder.swift
//  速递医疗 医生端
//
//  Created by hongyiting on 2017/12/6.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class MypatientConfirmOrder: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableData = ["未填","未填","未填","未填","未填","未填"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var title = ""
        switch indexPath.row {
        case 0:
            title = "姓名"
        case 1:
            title = "身份证"
        case 2:
            title = "身份证照片"
        case 3:
            title = "性别"
        case 4:
            title = "年龄"
        default:
            title = "住址"
        }
        let info = tableData[indexPath.row]
        let label_title = cell.viewWithTag(1) as! UILabel
        let label_info = cell.viewWithTag(2) as! UILabel
        label_info.text = info
        label_title.text = title
        return cell
    }
    
    @IBOutlet weak var tableView: BaseTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func click_save(_ sender: UIButton) {
        Toast("保存成功")
    }
    
    @IBAction func click_back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    

}
