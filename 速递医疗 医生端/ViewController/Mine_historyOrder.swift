//
//  Mine_historyOrder.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/9.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Mine_historyOrder: BaseRefreshController<OrderBean>,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initRefresh(scrollView: tableView, ApiMethod: API.listhistoryorder(self.selectedPage), refreshHandler: nil, getMoreHandler: {
            self.getMoreMethod = API.listhistoryorder(self.selectedPage)
        })
        self.header?.beginRefreshing()
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let nameLabel = cell.viewWithTag(1) as! UILabel
        let stateLabel = cell.viewWithTag(2) as! UILabel
        let timeLabel = cell.viewWithTag(3) as! UILabel
        let descLabel = cell.viewWithTag(4) as! UILabel
        let res = data[indexPath.row]
        nameLabel.text = res.familyname
        stateLabel.text = res.userorderstatename
        timeLabel.text = res.userorderetime
        descLabel.text = res.usersickdesc
        return cell
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
