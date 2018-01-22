////
////  SetDateCollectionViewCell.swift
////  速递医疗 医生端
////
////  Created by admin on 2017/12/9.
////  Copyright © 2017年 victor. All rights reserved.
////
//
//import UIKit
//
//class SetDateCollectionViewCell: UICollectionViewCell {
//    var data:MineCalendarBean?
//    var vc:BaseViewController?
//    @IBOutlet weak var descLabel: UILabel!
//    @IBOutlet weak var locLabel: UILabel!
//    @IBOutlet weak var timeLabel: UILabel!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//    func updateView(data:MineCalendarBean, vc:BaseViewController) {
//        self.data = data
//        self.vc = vc
//        descLabel.text = self.data!.doccalendaraffair ?? ""
//        timeLabel.text = "\( self.data!.doccalendartime!) \(self.data!.doccalendartimeinterval!)"
//        locLabel.text =  self.data!.docaddresslocation!
//    }
//    
//    @IBAction func delAction(_ sender: Any) {
//        let id = self.data?.doccalendarid
//        NetWorkUtil.init(method: .deletecalendar(id!)).newRequest(successhandler:{ (bean, json) in
//            
//                let vc = self.vc as! SetDateViewController
//                for (index,item) in vc.currentDate.enumerated() {
//                    if item.doccalendarid == id {
//                        vc.currentDate.remove(at: index)
//                    }
//                }
//                vc.collectionView.reloadData()
//        })
//    }
//}

