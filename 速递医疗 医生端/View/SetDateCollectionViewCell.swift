//
//  SetDateCollectionViewCell.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/9.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class SetDateCollectionViewCell: UICollectionViewCell {
    var data:MineCalendarBean?
    var vc:BaseRefreshController<MineCalendarBean>?
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func updateView(data:MineCalendarBean, vc:BaseRefreshController<MineCalendarBean>) {
        self.data = data
        self.vc = vc
        descLabel.text = self.data!.doccalendaraffair ?? ""
        timeLabel.text = "\( self.data!.doccalendarday!) \(self.data!.doccalendartime!)"
        locLabel.text =  self.data!.docaddresslocation!
    }
    
    @IBAction func delAction(_ sender: Any) {
        let id = self.data?.doccalendarid
        NetWorkUtil.init(method: .deletecalendar(id!)).newRequest { (bean, json) in
            速递医疗_医生端.showToast((self.vc?.view)!, bean.msg!)
            if bean.code == 100 {
                self.vc?.refreshData()
            }
        }
        
    }
}
