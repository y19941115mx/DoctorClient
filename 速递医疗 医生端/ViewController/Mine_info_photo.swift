//
//  Mine_info_photo.swift
//  速递医疗 医生端
//
//  Created by hongyiting on 2017/12/8.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Mine_info_photo: BasePickImgViewController,UICollectionViewDataSource, UICollectionViewDelegate{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var collectionView2: UICollectionView!
    
    var imgResource = [UIImage]()
    let Title = ["身份证照片","职称照片", "行医资格证照片","工作证照片","其他照片"]
//    type 1为身份证照片，2为职称照片，3为行医资格证照片，4为工作证照片，5为其他照片
    var type = 0
    var imgString = ""
    
    
    // Mark: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "请上传\(Title[self.type - 1])"
        handler = {selectedImage in
            self.imgResource.append(selectedImage)
            // 显示选中的图片
            self.collectionView2.reloadData()
        }
        for str in StringUTil.splitImage(str: imgString) {
            if str != "" {
                self.imgResource.append(ImageUtil.URLToImg(url: URL.init(string: str)!))
            }
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        for str in StringUTil.splitImage(str: imgString) {
//            if str != "" {
//                self.imgResource.append(ImageUtil.URLToImg(url: URL.init(string: str)!))
//            }
//        }
//        if imgResource.count != 0 {
//            self.collectionView2.reloadData()
//        }
//    }
    
    

    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return imgResource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusedCell", for: indexPath)
            let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.image = imgResource[indexPath.row]
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        AlertUtil.popAlert(vc: self, msg: "是否移除该图片") {
            self.imgResource.remove(at: indexPath.row)
            self.collectionView2.reloadData()
        }
    }
    
    
    // MARK: - acion
    @IBAction func addPicture(_ sender: UIButton) {
        updatePicture()
    }

   
    @IBAction func buttonAction(_ sender: UIButton) {
        if sender.tag == 0 {
            self.dismiss(animated: false, completion: nil)
        }else {
            // 保存
            let count = imgResource.count
            if count > 0 {
                var datas = [Data]()
                for i in 0..<count{
                    datas.append(ImageUtil.image2Data(image:imgResource[i]))
                }
                NetWorkUtil.init(method: .updatesecondinfo(self.type, datas)).newRequest(successhandler: { (bean, json) in
                    showToast(self.view, bean.msg!)
                })
            }else {
                showToast(self.view, "照片为空")
            }
        }
    }
    
}
