//
//  Mine_info_photo.swift
//  速递医疗 医生端
//
//  Created by hongyiting on 2017/12/8.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Mine_info_photo: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionView2: UICollectionView!
    var imageString:String?
    var showImgSource = [String]()
//    type 1为身份证照片，2为职称照片，3为行医资格证照片，4为工作证照片，5为其他照片
    var type = 0
    var imgResource = [#imageLiteral(resourceName: "add")]
    let Title = ["身份证照片", "工作证照片","行医资格证照片","职称照片","其他照片"]
    
    @IBOutlet weak var label: UILabel!
    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView.tag == 666 {
            return imgResource.count
        }else {
            return showImgSource.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if collectionView.tag == 666 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusedCell", for: indexPath)
            let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.image = imgResource[indexPath.row]
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusedCell", for: indexPath)
            let imageView = cell.viewWithTag(1) as! UIImageView
            ImageUtil.setAvator(path: self.showImgSource[indexPath.row], imageView: imageView)
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if collectionView.tag == 666 {
            // 点击了最后一个添加图片
            if indexPath.row == imgResource.count - 1 {
                if imgResource.count <= 4 {
                    pickImage(0)
                }else {
                    showToast(self.view, "请上传不多于四张图片")
                }
                
            }
        }
    
    }
    
    // MARK: - pickImage
    
    @IBAction func pickImage(_ type: Int) {
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        if type == 0{
            imagePickerController.sourceType = .photoLibrary
        }else {
            imagePickerController.sourceType = .camera
        }
        
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    //MARK:- UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.imgResource.insert(selectedImage, at: 0)
        // 显示选中的图片
        self.collectionView.reloadData()
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "请上传\(Title[self.type - 1])"
        
    }

   
    

    @IBAction func buttonAction(_ sender: UIButton) {
        if sender.tag == 0 {
            self.dismiss(animated: false, completion: nil)
        }else {
            // 保存
            let count = imgResource.count
            if count > 1 {
                var datas = [Data]()
                for i in 0..<(count-1){
                    datas.append(ImageUtil.image2Data(image:imgResource[i]))
                }
                NetWorkUtil.init(method: .updatesecondinfo(self.type, datas)).newRequest(handler: { (bean, json) in
                    showToast(self.view, bean.msg!)
                })
            }else {
                showToast(self.view, "照片为空")
            }
        }
    }
    
    
    
    

}
