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
    
    var city:String?
    var province:String?
    var area:String?
    
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
                self.ApiMethod = API.listsicksBytype(self.selectedPage, 2, APPLICATION.lat, APPLICATION.lon)
            case .sortByTime:
                self.ApiMethod = API.listsicksBytype(self.selectedPage, 1, APPLICATION.lat, APPLICATION.lon)
            }
        },  getMoreHandler: {
            switch self.sortType {
            case .sortByPatient:
                self.getMoreMethod = API.listsicks(self.selectedPage, APPLICATION.lat, APPLICATION.lon)
            case .sortByLoc:
                self.getMoreMethod = API.listsicksBytype(self.selectedPage, 2, APPLICATION.lat, APPLICATION.lon)
            case .sortByTime:
                self.getMoreMethod = API.listsicksBytype(self.selectedPage, 1, APPLICATION.lat, APPLICATION.lon)
            }
        })
        
        self.header?.beginRefreshing()
        
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
    
    // MARK: - private method
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
            make.height.equalTo(SCREEN_HEIGHT/2)
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
            cleanButton()
            sortByPatientBtn.setTitleColor(UIColor.LightSkyBlue, for: .normal)
            self.sortType = .sortByPatient
            self.header?.beginRefreshing()
            showToast(self.view, "按照推荐病人排序")
        // 时间
        case 10002:
            cleanButton()
            sortByTimeBtn.setTitleColor(UIColor.LightSkyBlue, for: .normal)
            self.sortType = .sortByTime
            self.header?.beginRefreshing()
            showToast(self.view, "按照时间排序")
        // 地点
        case 10003:
            cleanButton()
            sortByLocBtn.setTitleColor(UIColor.LightSkyBlue, for: .normal)
            self.sortType = .sortByLoc
            // 显示地点选择器
            showUIPickView()
            self.header?.beginRefreshing()
            showToast(self.view, "按照地点排序")
        default:
            // 完成地点选择
            self.cityPicker.isHidden = true
            self.myToolBar.isHidden = true
            //获取选中的省
            let p = self.addressArray[provinceIndex]
            province = p["state"]! as? String
            //获取选中的市
            let c = (p["cities"] as! NSArray)[cityIndex] as! [String: AnyObject]
            city = c["city"] as? String
            //获取选中的县（地区）
            area = ""
            if (c["areas"] as! [String]).count > 0 {
                area = (c["areas"] as! [String])[areaIndex]
            }
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
