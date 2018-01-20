//
//  Order_Detail.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/24.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Order_Detail: BasicCollectionViewBrowserController,UICollectionViewDataSource {
    
    @IBOutlet weak var imageLayout: UICollectionView!
    @IBOutlet weak var appointTimeLabel: UILabel!
    @IBOutlet weak var desc_label: UILabel!
    @IBOutlet weak var age_label: UILabel!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var avator_img: UIImageView!
    
    @IBOutlet weak var visitPriceType: UILabel!
    @IBOutlet weak var foodPriceType: UILabel!
    @IBOutlet weak var hotelPricteType: UILabel!
    @IBOutlet weak var transformPriceType: UILabel!
    
    @IBOutlet weak var foodPrice: UILabel!
    @IBOutlet weak var transformPrice: UILabel!
    @IBOutlet weak var visitPrice: UILabel!
    @IBOutlet weak var hotelPrice: UILabel!
    
    @IBOutlet weak var locLabel: UILabel!
    var userorderId:Int?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let image = cell.viewWithTag(1) as! UIImageView
        ImageUtil.setAvator(path: self.picArray[indexPath.row], imageView: image)
        return cell
    }
    
    
    
    @IBOutlet weak var height: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetWorkUtil<BaseBean<OrderBean>>.init(method: .getorderdetail(userorderId!)).newRequest(successhandler: { (bean, json) in
            
            let order = bean.data!
            self.updateView(bean: order)
            
        })
    }
    
    
    @IBAction func back_action(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    private func updateView(bean:OrderBean) {
        ImageUtil.setAvator(path: bean.userloginpix!, imageView: avator_img)
        name_label.text = bean.familyname
        age_label.text = "\(bean.familyage!)岁"
        desc_label.text = bean.usersickdesc
        if bean.usersickpic != nil &&  bean.usersickpic != ""{
            self.picArray = StringUTil.splitImage(str: bean.usersickpic!)
            self.imageLayout.reloadData()
        }else {
            self.imageLayout.isHidden = true
            self.height.constant -= 80
        }
        locLabel.text = bean.docaddresslocation
        appointTimeLabel.text = bean.userorderappointment
        visitPrice.text = "\(bean.userorderdprice!)"
        transformPriceType.text = "交通价格 \(bean.userordertpricetypename!   )"
        transformPrice.text = "\(bean.userordertprice!)"
        hotelPricteType.text = "住宿价格 \(bean.userorderapricetypename!)"
        hotelPrice.text = "\(bean.userorderaprice!)"
        foodPrice.text = "\(bean.userordereprice!)"
        foodPriceType.text = "餐饮价格 \(bean.userorderepricetypename!)"
        
    }
    
    
    
}
