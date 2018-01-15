//
//  EditViewController.swift
//  速递医疗 病人端
//
//  Created by hongyiting on 2017/12/5.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class EditViewController: BaseViewController,UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var flagLabel: UILabel!
    var msg:String = ""
    // 传过来的值
    var flag:Int = 0 // 0 是自我介绍 1 是擅长病情
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        flagLabel.isHidden = true
    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if StringUTil.trimmingCharactersWithWhiteSpaces(textView.text).count == 0 {
//            flagLabel.isHidden = false
//        }else {
//            flagLabel.isHidden = true
//        }
    
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NetWorkUtil.init(method: .getinfo).newRequest { (bean, json) in
            let data = json["data"]
            if self.flag == 0 {
                self.msg = data["docabs"].stringValue
            }else {
                self.msg = data["docexpert"].stringValue
            }
            if self.msg != "" {
                self.flagLabel.isHidden = true
                self.textView.text = self.msg
            }
        }
        
    }
    
    
    //MARK: - Action
    @IBAction func Save_action(_ sender: Any) {
        let text = textView.text ?? ""
        var api = API.updateintroduce(text)
        if flag == 1 {
            api = API.updateexpert(text)
        }
        NetWorkUtil.init(method: api).newRequest(handler: { (bean, json) in
            if bean.code == 100 {
                self.dismiss(animated: false, completion: nil)
            }else{
                showToast(self.view, bean.msg!)
            }
            
        })
    }
        
    @IBAction func Back_acion(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
}
