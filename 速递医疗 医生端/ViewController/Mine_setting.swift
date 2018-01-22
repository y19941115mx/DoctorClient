//
//  Mine_setting.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/11/21.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SnapKit

class Mine_setting: BaseTableInfoViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var messageObject:UMSocialMessageObject = {
        let shareObject = UMShareWebpageObject.shareObject(withTitle: "速运医疗", descr: "为更多的病人服务，不再让病人为挂号而苦恼。", thumImage: #imageLiteral(resourceName: "applogo"))
        //设置网页地址
        shareObject?.webpageUrl = "\(StaticClass.ShareURL)?docloginid=\(user_default.userId.getStringValue() ?? "")"
        
        //创建分享消息对象
        let messageObject = UMSocialMessageObject()
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject
        return messageObject
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        let titles = [["意见反馈","退出登录"],["应用分享"]]
        let infos:[[String]] = [["",""], [""]]
        initViewController(tableTiles: titles, tableInfo: infos, tableView: tableView) { (indexpath) in
            self.handler(indexPath: indexpath)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func handler(indexPath:IndexPath) {
        if indexPath.section == 1 {
            // 分享
            umengShare()
        }else {
            if indexPath.row == 0 {
                // 用户反馈界面
                let vc = FeedBackViewController()
                self.navigationController?.pushViewController(vc, animated: false)
            }else {
                user_default.logout("")
            }
        }
    }
    
    
    func umengShare() {
        UMSocialUIManager.showShareMenuViewInWindow { (type, userinfo) in
            UMSocialManager.default().share(to: type, messageObject: self.messageObject, currentViewController: self, completion: { (data, error) in
                if error != nil {
                    ToastError("分享失败")
                }
            })
        }
    }
}

class FeedBackViewController:BaseViewController {
    let textView = UITextView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavTitle(title: "意见反馈")
        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor.APPGrey
        self.view.addSubview(textView)
        let myToolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        let finishBtn = UIBarButtonItem(title: "完成", style: .done, target:self, action: #selector(FeedBackViewController.clickBtn(button:)))
        finishBtn.tag = 10000
        myToolBar.setItems([finishBtn], animated: false)
        textView.inputAccessoryView = myToolBar
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(self.view).multipliedBy(0.4)
        }
        let submitButton = UIButton()
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitle("提交", for: .normal)
        submitButton.backgroundColor = UIColor.APPColor
        submitButton.addTarget(self, action: #selector(FeedBackViewController.clickBtn(button:)), for: .touchUpInside)
        self.view.addSubview(submitButton)
        submitButton.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.height.equalTo(40)
        }
    }
    
    @objc func clickBtn(button:UIButton) {
        if button.tag == 10000 {
            self.textView.endEditing(true)
        }else {
            if StringUTil.trimmingCharactersWithWhiteSpaces(self.textView.text) != "" {
                NetWorkUtil.init(method: .addfeedback(self.textView.text)).newRequest(successhandler: { (bean, json) in
                    self.navigationController?.popViewController(animated: false)
                    Toast("提交成功")
                })
            }else {
                showToast(self.view, "信息为空")
            }
        }
    }
    
}
