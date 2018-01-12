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
            // 跳转到确认页面
            let viewController = UIStoryboard.init(name: "MyPatient", bundle: nil).instantiateViewController(withIdentifier: "ConfirmOrder") as! MypatientConfirmOrder
            viewController.orderId = self.data?.userorderid
            self.vc.present(viewController, animated: false, completion: nil)
            
        })
        
    }
    // 点击取消
    @IBAction func click_delete(_ sender: UIButton) {
        AlertUtil.popAlertWithDelAction(vc: self.vc, msg: "是否推荐给其他医生", oktitle: "是", deltitle: "否", okhandler: {
            let textField = UITextField()
            textField.placeholder = "请输入医生完整姓名"
            AlertUtil.popTextFields(vc: self.vc, title: "输入医生姓名", textfields: [textField], okhandler: { (textFields) in
                let text = textFields[0].text ?? ""
                if text == "" {
                    Toast("输入信息不能为空")
                }else {
                    NetWorkUtil<BaseListBean<DoctorBean>>.init(method: API.getdoctorbyname(text)).newRequest(handler: { (bean, json) in
                        if bean.code == 100 {
                            let mdata = bean.dataList
                            var docnames = [String]()
                            if mdata == nil {
                                Toast("无该医生信息")
                            }else {
                                for item in mdata! {
                                    docnames.append(item.name!)
                                }
                                AlertUtil.popMenu(vc: self.vc, title: "选择医生", msg: "", btns: docnames, handler: { (str) in
                                    let index = docnames.index(of: str)
                                    let doc = mdata![index!]
                                    NetWorkUtil<BaseAPIBean>.init(method: .refuseorder(self.data!.userorderid, doc.docId)).newRequestWithoutHUD { (bean, json) in
                                        Toast(bean.msg!)
                                        self.vc.refreshData()
                                    }
                                })
                            }
                        }
                    })
                }
            })
            
        }, delhandler: {
            NetWorkUtil<BaseAPIBean>.init(method: .refuseorder(self.data!.userorderid, 0)).newRequestWithoutHUD { (bean, json) in
                Toast(bean.msg!)
                self.vc.refreshData()
            }
        })
    }
    

}


