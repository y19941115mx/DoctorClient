//
//  ConsultationTableViewCell.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SnapKit

class ConsultationTableViewCell: UITableViewCell {
    var type = 0 // 默认只有取消按钮 1 时取消加确认按钮
    var data:ConsultationBean?
    var vc:BaseRefreshController<ConsultationBean>?
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pix: UIImageView!
    
    func updateViews(vc:BaseRefreshController<ConsultationBean>, bean:ConsultationBean) {
        self.vc = vc
        self.data = bean
        priceLabel.text = "\(bean.ordertotalhospprice!)"
        levelLabel.text = bean.hosplevelname
        nameLabel.text = bean.hospname
        ImageUtil.setAvator(path: bean.hosploginpix!, imageView: pix)
        
    }
    
    // 动态添加按钮
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if type == 0 {
            let delButton = UIButton()
            delButton.layer.cornerRadius = 5
            delButton.layer.borderColor = UIColor.orange.cgColor
            delButton.layer.borderWidth = 1
            delButton.setTitle("取消", for: .normal)
            self.contentView.addSubview(delButton)
            delButton.snp.makeConstraints { (make) in
                make.width.equalTo(40)
                make.bottom.equalTo(10)
                make.right.equalTo(10)
            }
            delButton.addTarget(self, action: #selector(self.delAction(button:)), for: .touchUpInside)
        } else if type == 1 {
            let confirmButton = UIButton()
            let delButton = UIButton()
            
            delButton.layer.cornerRadius = 5
            delButton.layer.borderColor = UIColor.blue.cgColor
            delButton.layer.borderWidth = 1
            delButton.setTitle("取消", for: .normal)
            self.contentView.addSubview(delButton)
            
            confirmButton.layer.cornerRadius = 5
            confirmButton.layer.borderColor = UIColor.blue.cgColor
            confirmButton.layer.borderWidth = 1
            confirmButton.setTitle("确定", for: .normal)
            self.contentView.addSubview(confirmButton)
            
            confirmButton.snp.makeConstraints { (make) in
                make.width.equalTo(40)
                make.bottom.equalTo(10)
                make.right.equalTo(10)
            }
            delButton.snp.makeConstraints { (make) in
                make.width.equalTo(40)
                make.bottom.equalTo(10)
                make.right.equalTo(confirmButton.snp.left).offset(-10)
            }
            confirmButton.addTarget(self, action: #selector(self.ConfirmAction(button:)), for: .touchUpInside)
            delButton.addTarget(self, action: #selector(self.delAction(button:)), for: .touchUpInside)
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    //    点击取消
    @objc private func delAction(button:UIButton) {
        AlertUtil.popAlert(vc: self.vc!, msg: "确认取消会诊，操作无法撤销") {
            let id = self.data?.hosporderid
            NetWorkUtil.init(method: API.cancelconsultation(id!)).newRequest(handler: { (bean, json) in
                if bean.code == 100 {
                    self.vc?.refreshData()
                }
                Toast(bean.msg!)
            })
        }
    }
    //    点击确定
    @objc private func ConfirmAction(button:UIButton) {
        let viewController = UIStoryboard.init(name: "Consultation", bundle: nil).instantiateViewController(withIdentifier: "confirmOrder") as! Consultation_confirmOrder
        viewController.orderId = self.data?.hosporderid
        self.vc!.present(viewController, animated: false, completion: nil)
    }
    
    
    
}
