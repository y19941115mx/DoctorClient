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
    
    var lon:String = "0"
    var lat:String = "0"
    
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
        initRefresh(scrollView: infoTableView, ApiMethod: .listsicks(self.selectedPage, lat, lon),  getMoreHandler: {
            switch self.sortType {
            case .sortByPatient:
                self.getMoreMethod = API.listsicks(self.selectedPage, self.lat, self.lon)
            case .sortByLoc:
                self.getMoreMethod = API.listsicksBytype(self.selectedPage, 2, self.lat, self.lon)
            case .sortByTime:
                self.getMoreMethod = API.listsicksBytype(self.selectedPage, 1, self.lat, self.lon)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let titleLabel = cell.viewWithTag(1) as! UILabel
        let sexLabel = cell.viewWithTag(2) as! UILabel
        let timeLabel = cell.viewWithTag(3) as! UILabel
        let descLabel = cell.viewWithTag(4) as! UILabel
        let patientImg = cell.viewWithTag(5) as! UIImageView
        let result = data[indexPath.row]
        titleLabel.text = result.familyname
        sexLabel.text = result.familymale
        if result.usersickptime == nil {
            timeLabel.text = ""
        }else {
            timeLabel.text = StringUTil.getComparedTimeStr(str: result.usersickptime!)
        }
        descLabel.text = result.usersickdesc
        ImageUtil.setAvator(path: result.userloginpix!, imageView: patientImg)
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
            ApiMethod = API.listsicks(self.selectedPage, lat, lon)
            self.sortType = .sortByPatient
            
            self.header?.beginRefreshing()
            showToast(self.view, "按照推荐病人排序")
        // 时间
        case 10002:
            cleanButton()
            sortByTimeBtn.setTitleColor(UIColor.LightSkyBlue, for: .normal)
            //更新上拉刷新与加载
            ApiMethod = API.listsicksBytype(self.selectedPage, 1, lat, lon)
            self.sortType = .sortByTime
            self.header?.beginRefreshing()
            showToast(self.view, "按照时间排序")
        // 地点
        case 10003:
            cleanButton()
            sortByLocBtn.setTitleColor(UIColor.LightSkyBlue, for: .normal)
            //更新上拉刷新与加载
            ApiMethod = API.listsicksBytype(self.selectedPage, 2, lat, lon)
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
    NetWorkUtil<sickDetailBean>.init(method:API.getsickdetail(patient.usersickid) , vc: self).newRequest(handler: {sick in
            self.sickBean = sick.sickDetail
            self.performSegue(withIdentifier: "ShowDetail", sender: self)
        })
    }
}
