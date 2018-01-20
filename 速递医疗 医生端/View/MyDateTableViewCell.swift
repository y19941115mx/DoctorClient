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
    var textField = UITextField()
    var vc:BaseRefreshController<OrderBean>?
    var data:OrderBean?
    var flag = 1 // 1 待确认 2 进行中
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateViews(vc:BaseRefreshController<OrderBean>, data:OrderBean) {
        self.vc = vc
        self.data = data
        if flag == 2 {
            button.setTitle("完成", for: .normal)
        }
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
        AlertUtil.popAlert(vc: self.vc!, msg: "确认执行该操作，该操作不可撤销") {
            if self.flag == 1 {
                NetWorkUtil.init(method: API.cancelorder(self.data!.userorderid)).newRequest(successhandler: { (bean, json) in
                    self.vc?.refreshBtn()
                    
                })
            }else {
                AlertUtil.popMenu(vc: self.vc!, title: "是否住院", msg: "", btns: ["是", "否"], handler: { (str) in
                    var isHospital = false
                    // 选择医院
                    if str == "是" {
                        self.textField.placeholder = "输入医院名称"
                        isHospital = true
                        AlertUtil.popTextFields(vc: self.vc!, title: "输入信息", textfields: [self.textField], okhandler: { (textFields) in
                            let text = textFields[0].text ?? ""
                            NetWorkUtil<BaseListBean<HospitalBean>>.init(method: API.gethospital(text)).newRequest(successhandler: { (bean, json) in
                                
                                let list = bean.dataList
                                var mBtns = [String]()
                                if list != nil {
                                    for item in list! {
                                        mBtns.append(item.hospname!)
                                    }
                                }
                                AlertUtil.popMenu(vc: self.vc!, title: "选择医院", msg: "", btns: mBtns, handler: { (str) in
                                    let index = mBtns.index(of: str)
                                    let hospital = list![index!]
                                    let id = hospital.hosploginid!
                                    NetWorkUtil.init(method: API.finishorder(self.data!.userorderid, isHospital, id)).newRequest(successhandler: { (bean, json) in
                                        Toast(bean.msg!)
                                        self.vc?.refreshBtn()
                                    })
                                })
                                
                            })
                            
                        })
                    }else {
                        NetWorkUtil.init(method: API.finishorder(self.data!.userorderid, isHospital,0)).newRequest(successhandler: { (bean, json) in
                            
                            self.vc?.refreshBtn()
                            
                        })
                    }
                    
                })
            }
        }
    }
    
}
