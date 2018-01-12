//
//  HomeViewController.swift
//  DoctorClient
//
//  Created by admin on 2017/8/18.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya
import ObjectMapper
import SnapKit

enum HomeType:Int {
    case sortByPatient, sortByTime,sortByLoc
}

class Home_main:BaseRefreshController<SickBean>, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    
    @IBOutlet weak var infoTableView: UITableView!
    
    @IBOutlet weak var sortByPatientBtn: UIButton!
    
    @IBOutlet weak var sortByTimeBtn: UIButton!
    
    @IBOutlet weak var sortByLocBtn: UIButton!
    
    var city = ""
    var province = ""
    var area = ""
    
    //所以地址数据集合
    var addressArray = [[String: AnyObject]]()
    //选择的省索引
    var provinceIndex = 0
    //选择的市索引
    var cityIndex = 0
    //选择的县索引
    var areaIndex = 0
    
    let cityPicker = UIPickerView()
    let myToolBar = UIToolbar()
    
    
    
    var sortType:HomeType = HomeType.sortByPatient
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化地址数据
        let path = Bundle.main.path(forResource: "address", ofType:"plist")
        self.addressArray = NSArray(contentsOfFile: path!) as! Array
        setUpNavTitle(title: "首页")
        //初始化navigationBar,添加按钮事件
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "message"), style: .plain, target: self, action: #selector(self.showContantList))
        initView()
        // 添加下拉刷新
        initRefresh(scrollView: infoTableView, ApiMethod: .listsicks(self.selectedPage, APPLICATION.lat, APPLICATION.lon), refreshHandler: {
            switch self.sortType {
            case .sortByPatient:
                self.ApiMethod = API.listsicks(self.selectedPage, APPLICATION.lat, APPLICATION.lon)
            case .sortByLoc:
                self.ApiMethod = API.listsicksByLoc(self.selectedPage,  APPLICATION.lat, APPLICATION.lon, self.province, self.city, self.area)
            case .sortByTime:
                self.ApiMethod = API.listsicksBytime(self.selectedPage, APPLICATION.lat, APPLICATION.lon)
            }
        },  getMoreHandler: {
            switch self.sortType {
            case .sortByPatient:
                self.getMoreMethod = API.listsicks(self.selectedPage, APPLICATION.lat, APPLICATION.lon)
            case .sortByLoc:
                self.getMoreMethod = API.listsicksByLoc(self.selectedPage,  APPLICATION.lat, APPLICATION.lon, self.province, self.city, self.area)
            case .sortByTime:
                self.getMoreMethod = API.listsicksBytime(self.selectedPage, APPLICATION.lat, APPLICATION.lon)
            }
        })
        // 环信登录
        self.loginHuanxin()
        // 获取数据
        self.header?.beginRefreshing()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return data.count
    }
    //1,2,3,4,5分别是3 个label 1 个 UIimage
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let id = "reusedCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! HomeMainTableViewCell
        let result = data[indexPath.row]
        cell.updateViews(result: result, vc: self)
        return cell
    }
    
    //MARK: - 重写父类方法 保存数据库
    
    override func getData() {
        //刷新数据
        self.selectedPage = 1
        let Provider = MoyaProvider<API>()
        if self.refreshHandler != nil {
            self.refreshHandler!()
        }
        Provider.request(self.ApiMethod!) { result in
            switch result {
            case let .success(response):
                do {
                    self.header?.endRefreshing()
                    let bean = Mapper<BaseListBean<SickBean>>().map(JSONObject: try response.mapJSON())
                    if bean?.code == 100 {
                        if bean?.dataList == nil {
                            bean?.dataList = [SickBean]()
                        }
                        self.data = (bean?.dataList)!
                        if self.data.count == 0{
                            //隐藏tableView,添加刷新按钮
                            self.showRefreshBtn()
                        }else {
                            // 保存数据库
                            for bean in self.data {
                                UserInfo.updateUserInfo(user_id: bean.userhuanxinaccount!, nick_name: bean.familyname!, user_photo: bean.userloginpix!)
                            }
                        }
                        
                        if self.isTableView {
                            let tableView = self.scrollView as! UITableView
                            tableView.reloadData()
                        }else {
                            let collectionView = self.scrollView as! UICollectionView
                            collectionView.reloadData()
                        }
                        
                    }else {
                        showToast(self.view, (bean?.msg!)!)
                    }
                    
                }catch {
                    //隐藏tableView,添加刷新按钮
                    if self.data.count == 0{
                        self.showRefreshBtn()
                    }
                    showToast(self.view,CATCHMSG)
                }
            case let .failure(error):
                self.header?.endRefreshing()
                if self.data.count == 0{
                    self.showRefreshBtn()
                }
                dPrint(message: "error:\(error)")
                showToast(self.view, ERRORMSG)
            }
        }
    }
    
    override func getMoreData() {
        self.selectedPage += 1
        
        //获取更多数据
        getMoreHandler()
        let Provider = MoyaProvider<API>()
        Provider.request(self.getMoreMethod!) { result in
            switch result {
            case let .success(response):
                self.footer?.endRefreshing()
                do {
                    let bean = Mapper<BaseListBean<SickBean>>().map(JSONObject: try response.mapJSON())
                    if bean?.code == 100 {
                        if bean?.dataList?.count == 0 || bean?.dataList == nil{
                            showToast(self.view, "已经到底了")
                            return
                        } else {
                            // 保存数据库
                            for bean in (bean?.dataList)! {
                                UserInfo.updateUserInfo(user_id: bean.userhuanxinaccount!, nick_name: bean.familyname!, user_photo: bean.userloginpix!)
                            }
                        }
                        self.data += (bean?.dataList)!
                        
                        if self.isTableView {
                            let tableView = self.scrollView as! UITableView
                            tableView.reloadData()
                        }else {
                            let CollectionView = self.scrollView as! UICollectionView
                            CollectionView.reloadData()
                        }
                        
                    }else {
                        showToast(self.view, (bean?.msg!)!)
                    }
                }catch {
                    self.footer?.endRefreshing()
                    showToast(self.view, CATCHMSG)
                }
            case let .failure(error):
                self.footer?.endRefreshing()
                dPrint(message: "error:\(error)")
                showToast(self.view, ERRORMSG)
            }
        }
    }
    
    // MARK: - private method
    private func loginHuanxin() {
        // 环信登录
        let account = user_default.account.getStringValue()
        let pass = user_default.password.getStringValue()
        
        EMClient.shared().login(withUsername: account!, password: pass, completion: { (name, error) in
            if error == nil {
                Toast("环信登录成功")
                self.updateView()
            }else {
                dPrint(message:"环信错误码:\(error?.code.rawValue)")
                Toast("环信登录失败")
            }
        })
        
        
    }
    
    func updateView(){
        // 获取所有会话
        let conversations:([EMConversation])? = EMClient.shared().chatManager.getAllConversations() as? [EMConversation]
        if conversations != nil {
            var count:Int32 = 0
            for conversation in conversations! {
                count += conversation.unreadMessagesCount
            }
            if count == 0 {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "message"), style: .plain, target: self, action: #selector(self.showContantList))
            }else {
                let buttonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "potMsg"), style: .plain, target: self, action: #selector(self.showContantList))
                buttonItem.tintColor = UIColor.red
                self.navigationItem.rightBarButtonItem = buttonItem
            }
        }
    }
    private func initView(){
        sortByLocBtn.addTarget(self, action: #selector(clickBtn(button:)), for: .touchUpInside)
        sortByTimeBtn.addTarget(self, action: #selector(clickBtn(button:)), for: .touchUpInside)
        sortByPatientBtn.addTarget(self, action: #selector(clickBtn(button:)), for: .touchUpInside)
    }
    
    private func cleanButton(){
        sortByLocBtn.setTitleColor(UIColor.black, for: .normal)
        sortByTimeBtn.setTitleColor(UIColor.black, for: .normal)
        sortByPatientBtn.setTitleColor(UIColor.black, for: .normal)
    }
    
    @objc private func showContantList() {
        let viewController = ConversationListViewController()
        viewController.setUpNavTitle(title: "会话列表")
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    // 显示pickerView
    private func showUIPickView() {
        self.cityPicker.isHidden = false
        self.myToolBar.isHidden = false
        self.view.addSubview(self.cityPicker)
        cityPicker.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(SCREEN_HEIGHT/3)
        }
        self.view.addSubview(self.myToolBar)
        myToolBar.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(self.cityPicker.snp.top)
        }
        let finishBtn = UIBarButtonItem(title: "完成", style: .done, target:self, action: #selector(self.clickBtn(button:)))
        finishBtn.tag = 10004
        myToolBar.setItems([finishBtn], animated: false)
        cityPicker.delegate = self
        cityPicker.dataSource = self
        cityPicker.backgroundColor = UIColor.white
    }

    //MARK: - action
    @objc func clickBtn(button:UIButton){
        switch button.tag {
        // 推荐病人
        case 10001:
            self.cityPicker.isHidden = true
            self.myToolBar.isHidden = true
            self.refreshBtn()
            cleanButton()
            sortByPatientBtn.setTitleColor(UIColor.LightSkyBlue, for: .normal)
            self.sortType = .sortByPatient
//            self.header?.beginRefreshing()
            showToast(self.view, "按照推荐病人排序")
        // 时间
        case 10002:
            self.refreshBtn()
            self.cityPicker.isHidden = true
            self.myToolBar.isHidden = true
            cleanButton()
            sortByTimeBtn.setTitleColor(UIColor.LightSkyBlue, for: .normal)
            self.sortType = .sortByTime
            showToast(self.view, "按照时间排序")
        // 地点
        case 10003:
            cleanButton()
            sortByLocBtn.setTitleColor(UIColor.LightSkyBlue, for: .normal)
            self.sortType = .sortByLoc
            // 显示地点选择器
            showUIPickView()
            showToast(self.view, "按照地点排序")
        default:
            // 完成地点选择
            self.cityPicker.isHidden = true
            self.myToolBar.isHidden = true
            //获取选中的省
            let p = self.addressArray[provinceIndex]
            province = p["state"]! as! String
            //获取选中的市
            let c = (p["cities"] as! NSArray)[cityIndex] as! [String: AnyObject]
            city = c["city"] as! String
            //获取选中的县（地区）
            area = ""
            if (c["areas"] as! [String]).count > 0 {
                area = (c["areas"] as! [String])[areaIndex]
            }
            // 刷新数据
            self.refreshBtn()
        }
    }
    
    //MARK: - navigation Methond
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let indexPath = infoTableView.indexPathForSelectedRow!
            let patient = data[indexPath.row]
            let vc = segue.destination as! Home_detail
            vc.patientId = patient.usersickid
            self.infoTableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    // MARK: - UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.addressArray.count
        } else if component == 1 {
            let province = self.addressArray[provinceIndex]
            return province["cities"]!.count
        } else {
            let province = self.addressArray[provinceIndex]
            if let city = (province["cities"] as! NSArray)[cityIndex]
                as? [String: AnyObject] {
                return city["areas"]!.count
            } else {
                return 0
            }
        }
    }
    //设置选择框各选项的内容，继承于UIPickerViewDelegate协议
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if component == 0 {
            return self.addressArray[row]["state"] as? String
        }else if component == 1 {
            let province = self.addressArray[provinceIndex]
            let city = (province["cities"] as! NSArray)[row]
                as! [String: AnyObject]
            return city["city"] as? String
        }else {
            let province = self.addressArray[provinceIndex]
            let city = (province["cities"] as! NSArray)[cityIndex]
                as! [String: AnyObject]
            return (city["areas"] as! NSArray)[row] as? String
        }
    }
    
    //选中项改变事件（将在滑动停止后触发）
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        //根据列、行索引判断需要改变数据的区域
        switch (component) {
        case 0:
            provinceIndex = row;
            cityIndex = 0;
            areaIndex = 0;
            pickerView.reloadComponent(1);
            pickerView.reloadComponent(2);
            pickerView.selectRow(0, inComponent: 1, animated: false)
            pickerView.selectRow(0, inComponent: 2, animated: false)
        case 1:
            cityIndex = row;
            areaIndex = 0;
            pickerView.reloadComponent(2);
            pickerView.selectRow(0, inComponent: 2, animated: false)
        case 2:
            areaIndex = row;
        default:
            break;
        }
    }
    
}
