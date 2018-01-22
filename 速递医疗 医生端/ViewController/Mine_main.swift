//
//  MineViewController.swift
//  DoctorClient
//
//  Created by admin on 2017/8/18.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SnapKit



class Mine_main: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var careerLable: UILabel!


    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!

    
    @IBOutlet weak var titleView: UIView!
    var msg:String = ""
    // 审核状态label
    lazy var stateLabelView:TriLabelView = {
        let triLabelView = TriLabelView()
        triLabelView.position = .BottomRight
        triLabelView.labelText = "审核中"
        triLabelView.viewColor = UIColor.orange
        triLabelView.textColor = UIColor.white
        triLabelView.labelFont = UIFont.systemFont(ofSize: 12)
        triLabelView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(Mine_main.click_state_label))
        triLabelView.addGestureRecognizer(gesture)
        titleView.addSubview(triLabelView)
        triLabelView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(120)
            make.width.equalTo(120)
        }
        return triLabelView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = user_default.username.getStringValue()
        if nameLabel.text == "" {
            nameLabel.text = "匿名用户"
        }
        careerLable.text = user_default.title.getStringValue()
        idLabel.text = "id: \(user_default.userId.getStringValue()!)"
        ImageUtil.setAvator(path: user_default.pix.getStringValue()!, imageView: photoImageView)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 更新账号审核状态
        NetWorkUtil.init(method: .getreviewinfo).newRequestWithOutHUD(successhandler:  { (bean, json) in
            let data = json["data"]
            let name = data["typename"].stringValue
            let type = data["type"].intValue
            if type == 4 {
                self.stateLabelView.labelText = "审核失败"
                self.msg = data["msg"].stringValue
            }else {
                self.stateLabelView.labelText = name
            }
        })
    }
    
    //MARK:- action
    @IBAction func pickImage(_ sender: UIButton) {
        AlertUtil.popMenu(vc: self, title: "上传图片", msg: "上传图片", btns: ["拍照", "从图库选择"], handler: {btn in
            if btn == "拍照" {
                self.pickImageFromCamera()
            }else {
                self.pickImageFromPhotoLib()
            }
        })

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
        NetWorkUtil<BaseAPIBean>.init(method: API.updatepix(ImageUtil.image2Data(image: selectedImage))).newRequest(successhandler: {bean,json  in
            showToast(self.view, bean.msg!)
        })
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)

    }
    
    // MARK: - 私有方法
    func pickImageFromPhotoLib() {
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)

        
    }
    func pickImageFromCamera() {
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .camera
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
        
    }

    @IBAction func unwindToMine(sender: UIStoryboardSegue){

    }
    
    @objc func click_state_label() {
        if msg != "" {
            AlertUtil.popAlert(vc: self, msg: msg, hasCancel: false,okhandler: {})
        }
    }
}

