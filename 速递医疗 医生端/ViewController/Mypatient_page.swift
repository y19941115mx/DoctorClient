//
//  DoctorPageViewController.swift
//  PatientClient
//
//  Created by admin on 2017/10/20.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper

class Mypatient_page_check: BaseRefreshController<mypatient_check>, UITableViewDataSource {
    @IBOutlet weak var tableView: BaseTableView!
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "reuseIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! MypatientTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let res = data[indexPath.row]
        cell.updateViews(modelBean: res)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initRefresh(scrollView: tableView, ApiMethod: API.listgraborders(selectedPage), refreshHandler: nil, getMoreHandler: {
            self.getMoreMethod = API.listgraborders(self.selectedPage)
        })
        
        self.header?.beginRefreshing()
    }


}

class Mypatient_page_checked: BaseRefreshController<mypatient_checked>, UITableViewDataSource {
    @IBOutlet weak var tableView: BaseTableView!
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "reuseIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! MypatientTableViewCell2
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let res = data[indexPath.row]
        cell.updateViews(modelBean: res)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initRefresh(scrollView: tableView, ApiMethod: API.listordertoconfirm(selectedPage), refreshHandler: nil, getMoreHandler: {
            self.getMoreMethod = API.listordertoconfirm(self.selectedPage)
        })
        
        self.header?.beginRefreshing()
    }
    
    
}



