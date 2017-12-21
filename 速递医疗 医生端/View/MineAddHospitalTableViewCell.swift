//
//  MineAddHospitalTableViewCell.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class MineAddHospitalTableViewCell: UITableViewCell {
    var vc:BaseRefreshController<MineLocationBean>?
    var data:MineLocationBean?

    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var detailLocationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateViews(vc:BaseRefreshController<MineLocationBean>, data:MineLocationBean) {
        self.vc = vc
        self.data = data
        locationLabel.text = data.docaddresslocation!
        detailLocationLabel.text = "\(data.docaddressprovince!)\(data.docaddresscity!)\(data.docaddressarea ?? "")\(data.docaddressother ?? "")"
    }
    
    @IBAction func delAction(_ sender: Any) {
        AlertUtil.popAlert(vc: self.vc!, msg: "确认删除该地址") {
            let id = self.data?.docaddressid
            NetWorkUtil.init(method: .deleteaddress(id!)).newRequest(handler: { (bean, json) in
                if bean.code == 100 {
                    self.vc?.refreshData()
                }
                速递医疗_医生端.showToast(self.vc!.view, bean.msg!)
            })
        }
    }
}
