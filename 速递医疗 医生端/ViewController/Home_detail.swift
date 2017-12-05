//
//  PatientDetailViewController.swift
//  DoctorClient
//
//  Created by admin on 2017/8/31.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Home_detail: BaseViewController, UICollectionViewDataSource{
    var sickBean:sickDetail?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var patientName: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var describeLabel: UILabel!
    
    @IBOutlet weak var imageLayout: UICollectionView!
    
    var images = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageLayout.dataSource = self
        if let sick = sickBean {
            titleLabel.text = sick.usersickdesc
            timeLabel.text =  sick.usersickptime
            patientName.text = sick.familyname
            if sick.usersickdesc == nil {
                sick.usersickdesc = ""
            }
            describeLabel.text = "病情描述： " + sick.usersickdesc!
            if sick.usersickpic == nil {
                sick.usersickpic = ""
            }
            self.images = StringUTil.splitImage(str: sick.usersickpic!)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cellIdentifilter = "reusedCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifilter, for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        ImageUtil.setAvator(path: images[indexPath.row], imageView: imageView)
        return cell
    }
    
    // MARK: - 点击事件
    @IBAction func click_btn(_ sender: UIButton) {
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



