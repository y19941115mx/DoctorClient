//
//  PatientDetailViewController.swift
//  DoctorClient
//
//  Created by admin on 2017/8/31.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import HJPhotoBrowser

class Home_detail: BasicCollectionViewBrowserController, UICollectionViewDataSource{
    
    
    var sickBean:sickDetail?
    
    var patientId:Int?
    
    
    @IBOutlet weak var patientName: UILabel!
    
    @IBOutlet weak var deptLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var pixImgView: UIImageView!
    @IBOutlet weak var describeLabel: UILabel!
    
    @IBOutlet weak var imageLayout: UICollectionView!
    
//    var images = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController(mCollectionView: imageLayout)
        imageLayout.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NetWorkUtil<sickDetailBean>.init(method:API.getsickdetail(self.patientId!) ).newRequest(handler: {sick,json  in
            self.sickBean = sick.sickDetail
            if let sick = self.sickBean {
                self.patientName.text = sick.familyname
                self.sexLabel.text = sick.familymale
                self.ageLabel.text = "\(sick.familyage)"
                self.deptLabel.text = "\(sick.usersickprimarydept ?? "") \(sick.usersickseconddept ?? "")"
                self.timeLabel.text =  sick.usersickptime
                if sick.usersickdesc == nil {
                    sick.usersickdesc = ""
                }
                self.describeLabel.text = sick.usersickdesc!
                if sick.usersickpic != nil &&  sick.usersickpic != ""{
                    self.picArray = StringUTil.splitImage(str: sick.usersickpic!)
                    self.imageLayout.reloadData()
                }
                ImageUtil.setAvator(path: sick.userloginpix!, imageView: self.pixImgView)
                
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cellIdentifilter = "reusedCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifilter, for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        ImageUtil.setAvator(path: picArray[indexPath.row], imageView: imageView)
        return cell
    }
    
    // MARK: - 点击事件
    @IBAction func click_btn(_ sender: UIButton) {
        if sender.tag == 666{
            self.dismiss(animated: false, completion: nil)
            return
        }
        let priceTextField = UITextField()
        priceTextField.placeholder = "参考价格"
        priceTextField.keyboardType = .numberPad
        AlertUtil.popTextFields(vc: self, title: "输入参考价格", textfields: [priceTextField]){ textFields in
            let price = Double(textFields[0].text!)
            NetWorkUtil<BaseAPIBean>.init(method: API.graborder((self.sickBean?.usersickid)!, price!)).newRequest(handler: {bean, json in
                self.dismiss(animated: false, completion: nil)
                showToast((APPLICATION.window?.rootViewController?.view)!, bean.msg!)
            })
        }
    }
    
}



