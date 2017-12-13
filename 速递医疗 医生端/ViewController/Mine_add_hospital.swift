//
//  Mine_add_hospital.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit


class Mine_add_hospital: BaseRefreshController<MineLocationBean>, AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MineAddHospitalTableViewCell
        if cell == nil {
            cell =  Bundle.main.loadNibNamed("MineAddHospitalTableViewCell", owner: nil, options: nil)?.last as? MineAddHospitalTableViewCell
        }
        let bean = data[indexPath.row]
        cell?.updateViews(vc: self, data: bean)
        return cell!
    }
    

    @IBOutlet weak var tabelView: BaseTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let search = AMapSearchAPI()
        initNoFooterRefresh(scrollView: tabelView, ApiMethod: .getalladdress, isTableView: true)
        self.header?.beginRefreshing()
    }

    //
    @IBAction func addAction(_ sender: Any) {
        
    }
    
    @IBAction func backAcion(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
