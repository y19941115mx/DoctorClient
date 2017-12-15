//
//  MyDateTableViewCell.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class MyDateTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var hospitalLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    var vc:BaseRefreshController<OrderBean>?
    var data:OrderBean?
    var flag = 1 // 1 待确认 2 进行中
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if flag == 2 {
            button.setTitle("完成", for: .normal)
        }
    }
    
    func updateViews(vc:BaseRefreshController<OrderBean>, data:OrderBean) {
        nameLabel.text = data.familyname!
        descLabel.text = data.usersickdesc!
        priceLabel.text = "\(data.userorderprice!)"
        hospitalLabel.text = data.docaddresslocation!
        timeLabel.text = data.userorderappointment!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func delAction(_ sender: UIButton) {
        AlertUtil.popAlert(vc: self.vc!, msg: "确认取消订单，取消后不可撤销") {
            if self.flag == 1 {
                NetWorkUtil.init(method: API.cancelorder(self.data!.userorderid)).newRequest(handler: { (bean, json) in
                    if bean.code == 100 {
                        self.vc?.refreshData()
                    }
                    Toast(bean.msg!)
                })
            }else {
                AlertUtil.popMenu(vc: self.vc!, title: "是否住院", msg: "", btns: ["是", "否"], handler: { (str) in
                    var isHospital = false
                    if str == "是" {
                        isHospital = true
                    }
                    NetWorkUtil.init(method: API.finishorder(self.data!.userorderid, isHospital)).newRequest(handler: { (bean, json) in
                        if bean.code == 100 {
                            self.vc?.refreshData()
                        }
                        Toast(bean.msg!)
                    })
                })
            }
        }
    }
    
}
