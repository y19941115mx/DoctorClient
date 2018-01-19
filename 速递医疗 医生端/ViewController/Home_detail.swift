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
    var account:String?
    var patientNameText:String?
    
    @IBOutlet weak var pixImgView: UIImageView!
    @IBOutlet weak var describeLabel: UILabel!
    
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var imageLayout: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageLayout.delegate = self
        imageLayout.dataSource = self
        imageLayout.showsVerticalScrollIndicator = true
        self.initData()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = true
    }
    private func initData() {
        
        NetWorkUtil<sickDetailBean>.init(method:API.getsickdetail(self.patientId!) ).newRequest(handler: {sick,json  in
            self.sickBean = sick.sickDetail
            if let sick = self.sickBean {
                self.account = sick.userhuanxinaccount
                self.patientNameText = sick.familyname
                self.patientName.text = self.patientNameText
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
                } else {
                    self.imageLayout.isHidden = true
                    self.height.constant -= 100
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
            self.navigationController?.popViewController(animated: false)
            return
        }
        let priceTextField = UITextField()
        priceTextField.placeholder = "参考价格"
        priceTextField.keyboardType = .decimalPad
        AlertUtil.popTextFields(vc: self, title: "输入参考价格", textfields: [priceTextField]){ textFields in
            let price = Double(textFields[0].text!)
            NetWorkUtil<BaseAPIBean>.init(method: API.graborder((self.sickBean?.usersickid)!, price!)).newRequest(handler: {bean, json in
                if bean.code == 100 {
                    self.navigationController?.setNavigationBarHidden(false, animated: false)
                    self.navigationController?.popViewController(animated: false)
                    NavigationUtil<Mypatient_main>.setTabBarSonController(index: 1, handler: { (vc) in
                        let sonvc = vc.vcs[0] as! Mypatient_page_check
                        sonvc.refreshBtn()
                    })
                    
                }else {
                    showToast(self.view, bean.msg!)
                }
            })
        }
    }
    
    @IBAction func sixin(_ sender: UIButton) {
        if account == nil || account == "" {
            Toast("环信账号异常")
            return
        }
        let viewController = ChatViewController.init(conversationChatter: self.account, conversationType: EMConversationTypeChat)
        viewController?.setUpNavTitle(title: (self.patientNameText)!)
        viewController?.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(viewController!, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}



