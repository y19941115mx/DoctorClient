//
//  HomeMainTableViewCell.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/1.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class MypatientTableViewCell: UITableViewCell {
    var data:mypatient_check?
    var vc = BaseRefreshController<mypatient_check>()
    
    
    
    @IBOutlet weak var pix_imv: UIImageView!
    
    
    @IBOutlet weak var name_label: UILabel!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var sexLabel: UILabel!
    
    
    @IBOutlet weak var descLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func updateViews(modelBean:mypatient_check, vc:BaseRefreshController<mypatient_check>) {
        self.data = modelBean
        self.vc = vc
        ImageUtil.setAvator(path: modelBean.userloginpix!, imageView: pix_imv)
        name_label.text = modelBean.familyname
        timeLabel.text = modelBean.preordertime
        sexLabel.text = modelBean.familymale
        descLabel.text = modelBean.usersickdesc
    }
    // 点击取消
    @IBAction func click_delete(_ sender: UIButton) {
        AlertUtil.popAlert(vc: self.vc, msg: "确认取消", okhandler: {
            NetWorkUtil<BaseAPIBean>.init(method: .cancelgraborder(self.data!.preorderid)).newRequest(handler: { (bean, json) in
                Toast(bean.msg!)
                self.vc.refreshData()
            })
        })
    }
}

class MypatientTableViewCell2: UITableViewCell {
    var data:mypatient_checked?
    var vc = BaseRefreshController<mypatient_checked>()
    
    
    
    @IBOutlet weak var pix_imv: UIImageView!
    
    
    @IBOutlet weak var name_label: UILabel!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var sexLabel: UILabel!
    
    
    @IBOutlet weak var descLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func updateViews(modelBean:mypatient_checked, vc:BaseRefreshController<mypatient_checked>) {
        self.data = modelBean
        self.vc = vc
        ImageUtil.setAvator(path: modelBean.userloginpix!, imageView: pix_imv)
        name_label.text = modelBean.familyname
        timeLabel.text = modelBean.userorderptime
        sexLabel.text = modelBean.familymale
        descLabel.text = modelBean.usersickdesc
    }
    // 点击确定
    @IBAction func click_confirm(_ sender: Any) {
        AlertUtil.popAlert(vc: self.vc, msg: "是否确认订单", okhandler: {
            
        })
        
    }
    // 点击取消
    @IBAction func click_delete(_ sender: UIButton) {
        AlertUtil.popAlert(vc: self.vc, msg: "是否推荐给其他医生", okhandler: {})
        NetWorkUtil<BaseAPIBean>.init(method: .refuseorder(self.data!.userorderid, 0)).newRequestWithoutHUD { (bean, json) in
            Toast(bean.msg!)
            self.vc.refreshData()
        }
    }
}


