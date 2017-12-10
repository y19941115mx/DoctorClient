//
//  MinePocketCollectionViewCell.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/11/3.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class MinePocketCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_payway: UILabel!
    @IBOutlet weak var label_money: UILabel!
    @IBOutlet weak var Label_time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updataView(bean:MineTradeBean) {
        label_name.text = bean.paysendername
        label_payway.text = bean.paymodename
        label_money.text = String(describing: bean.paytotalamount)
        Label_time.text = bean.paycreattime
    }

}
