//
//  Consultation_page.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Consultation_page: BaseRefreshController<ConsultationBean>, UITableViewDataSource, UITableViewDelegate {
    var flag = 1

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bean = data[indexPath.row]
        let viewController = UIStoryboard.init(name: "Consultation", bundle: nil).instantiateViewController(withIdentifier: "confirmOrder") as! Consultation_confirmOrder
        viewController.orderId = bean.hosporderid
        viewController.flag = 1
        self.present(viewController, animated: false, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ConsultationTableViewCell
        if cell == nil {
            cell =  Bundle.main.loadNibNamed("ConsultationTableViewCell", owner: nil, options: nil)?.last as? ConsultationTableViewCell
        }
        // 待确认订单显示确认按钮
        cell?.type = flag
        let bean = data[indexPath.row]
        cell?.updateViews(vc: self, bean: bean)
        cell?.selectionStyle = .none
        return cell!
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
        initRefresh(scrollView: tableView, ApiMethod: .listconsultation(self.selectedPage, self.flag), refreshHandler: nil, getMoreHandler: {
            self.getMoreMethod = .listconsultation(self.selectedPage, self.flag)
        })
        self.header?.beginRefreshing()

        // Do any additional setup after loading the view.
    }

    

}
