////
////  MineViewController.swift
////  DoctorClient
////
////  Created by admin on 2017/8/18.
////  Copyright © 2017年 victor. All rights reserved.
////
//
//import UIKit
//import SVProgressHUD
//import SwiftyJSON
//
//
//class MineViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var careerLable: UILabel!
//    
//    @IBOutlet weak var typeLabel: UILabel!
//    
//    @IBOutlet weak var idLabel: UILabel!
//    @IBOutlet weak var photoImageView: UIImageView!
//    
//    let user = UserDefaultUtils.getUserDefaultsObject()
//    
//    
//    var imageUrl = Constant.BASEAPI.imageUrl + getUserDefaultStringValue(key: "avator", defaultValue: "1.jpg")
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        nameLabel.text = user.name
//        careerLable.text = user.career
//        typeLabel.text = user.flag ? "已认证" : "未认证"
//        idLabel.text = "ID:0000000" + user.id
//        ImageUtil.setAvator(path: user.avator, imageView: photoImageView)
//        
//    }
//    //MARK:- action
//    @IBAction func pickImageFromPhotoLib(_ sender: UIButton) {
//        let imagePickerController = UIImagePickerController()
//        
//        // Only allow photos to be picked, not taken.
//        imagePickerController.sourceType = .photoLibrary
//        
//        // Make sure ViewController is notified when the user picks an image.
//        imagePickerController.delegate = self
//        present(imagePickerController, animated: true, completion: nil)
//        
//    }
//    
//    //MARK:- UIImagePickerControllerDelegate
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
//        // Dismiss the picker if the user canceled.
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
//            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//        }
//
//        // 显示选中的图片
//        photoImageView.image = selectedImage
//        //上传头像
//        SVProgressHUD.show()
//        upLoadPhoto(data: [ImageUtil.image2Data(image: selectedImage)], type: "0", name: ["uploadImage"], success: { response in
//            SVProgressHUD.dismiss()
//            showToast(vc: self, text: "上传成功")
//            // 获取新的图片地址
//            let json = JSON(response)
//            dPrint(message: json)
//            guard let image = json["data"].string else{
//                fatalError("json 解析错误")
//            }
//            // 更新头像
//            self.user.setAvator(newValue:image)
//            UserDefaultUtils.setUserDefaultsObject(model: self.user)
//            ImageUtil.setAvator(path: image, imageView: self.photoImageView)
//        }, failture: { error in
//            SVProgressHUD.dismiss()
//            showToast(vc: self, text: "上传失败")
//        })
//        // Dismiss the picker.
//        dismiss(animated: true, completion: nil)
//        
//    }
//    
//    
//    
//    @IBAction func unwindToMine(sender: UIStoryboardSegue){
//        
//    }
//}

