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

enum HomeType:Int {
    case sortByPatient, sortByTime,sortByLoc
}

class Home_main:BaseRefreshController<SickBean>, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var infoTableView: UITableView!
    
    @IBOutlet weak var sortByPatientBtn: UIButton!
    
    @IBOutlet weak var sortByTimeBtn: UIButton!
    
    @IBOutlet weak var sortByLocBtn: UIButton!
    
    
    var sortType:HomeType = HomeType.sortByPatient
    var sickBean:sickDetail?
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavTitle(title: "首页")
        // 去除多余列表
        infoTableView.tableFooterView = UIView()
        //初始化navigationBar,添加按钮事件
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
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
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

    //MARK: - action
    @objc func clickBtn(button:UIButton){
        switch button.tag {
        // 推荐病人
        case 10001:
            cleanButton()
            sortByPatientBtn.setTitleColor(UIColor.LightSkyBlue, for: .normal)
            //更新下拉刷新与加载
            ApiMethod = API.listsicks(self.selectedPage, APPLICATION.lat, APPLICATION.lon)
            self.sortType = .sortByPatient
            
            self.header?.beginRefreshing()
            showToast(self.view, "按照推荐病人排序")
        // 时间
        case 10002:
            cleanButton()
            sortByTimeBtn.setTitleColor(UIColor.LightSkyBlue, for: .normal)
            //更新上拉刷新与加载
            ApiMethod = API.listsicksBytype(self.selectedPage, 1, APPLICATION.lat, APPLICATION.lon)
            self.sortType = .sortByTime
            self.header?.beginRefreshing()
            showToast(self.view, "按照时间排序")
        // 地点
        case 10003:
            cleanButton()
            sortByLocBtn.setTitleColor(UIColor.LightSkyBlue, for: .normal)
            //更新上拉刷新与加载
            ApiMethod = API.listsicksBytype(self.selectedPage, 2, APPLICATION.lat, APPLICATION.lon)
            self.sortType = .sortByLoc
            self.header?.beginRefreshing()
            showToast(self.view, "按照地点排序")
        default:
            showToast(self.view, "error")
        }
    
    }
    
    
    //MARK: - navigation Methond
    @IBAction func unwindToHome(sender: UIStoryboardSegue){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let vc = segue.destination as! Home_detail
            vc.sickBean = self.sickBean
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let patient = data[indexPath.row]
        NetWorkUtil<sickDetailBean>.init(method:API.getsickdetail(patient.usersickid) , vc: self).newRequest(handler: {sick,json  in
            self.sickBean = sick.sickDetail
            self.performSegue(withIdentifier: "ShowDetail", sender: self)
        })
    }
    
    
    
}
