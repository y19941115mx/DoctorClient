//
//  Date_page.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SnapKit

class Date_page: BaseRefreshController<OrderBean>, UITableViewDataSource,UITableViewDelegate {
    var flag = 1
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MyDateTableViewCell
        if cell == nil {
            cell =  Bundle.main.loadNibNamed("MyDateTableViewCell", owner: nil, options: nil)?.last as? MyDateTableViewCell
        }
        cell?.flag = flag
        let bean = data[indexPath.row]
        cell?.updateViews(vc: self, data: bean)
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Date", bundle: nil).instantiateViewController(withIdentifier: "OrderDetail") as! Order_Detail
        vc.userorderId = data[indexPath.row].userorderid
        self.present(vc, animated: false, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = BaseTableView()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        tableView.dataSource = self
        tableView.delegate = self
        initRefresh(scrollView: tableView, ApiMethod: .getorder(self.selectedPage, self.flag), refreshHandler: nil, getMoreHandler: {
            self.getMoreMethod = .getorder(self.selectedPage, self.flag)
        })
        self.header?.beginRefreshing()
    }

   

}
