//
//  MineViewController.swift
//  DoctorClient
//
//  Created by admin on 2017/8/18.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Moya
import ObjectMapper


class Mine_main: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var careerLable: UILabel!

    @IBOutlet weak var typeLabel: UILabel!

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = user_default.username.getStringValue()
        if nameLabel.text == nil {
            nameLabel.text = "匿名用户"
        }
        careerLable.text = user_default.title.getStringValue()
        typeLabel.text = user_default.typename.getStringValue()
        idLabel.text = user_default.userId.getStringValue()
        ImageUtil.setAvator(path: user_default.pix.getStringValue()!, imageView: photoImageView)

    }
    //MARK:- action
    @IBAction func pickImageFromPhotoLib(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()

        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary

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

        // 显示选中的图片
        photoImageView.image = selectedImage
        //上传头像
        SVProgressHUD.show()
        NetWorkUtil<BaseAPIBean>.init(method: API.updatepix(ImageUtil.image2Data(image: selectedImage)), vc: self).newRequest(handler: {bean in
            showToast(self.view, bean.msg!)
        })
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)

    }



    @IBAction func unwindToMine(sender: UIStoryboardSegue){

    }
}

