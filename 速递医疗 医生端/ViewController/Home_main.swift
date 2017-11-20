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

class Home_main:BaseRefreshController<SickBean>, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var infoTableView: UITableView!
    
    @IBOutlet weak var sortByPatientBtn: UIButton!
    
    @IBOutlet weak var sortByTimeBtn: UIButton!
    
    @IBOutlet weak var sortByLocBtn: UIButton!
    
    var lon:String = "0"
    var lat:String = "0"
    
    var api:API?
    var sickBean:sickDetail?
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavTitle(title: "首页")
        api = .listsicks(self.selectedPage, lat, lon)
        // 去除多余列表
        infoTableView.tableFooterView = UIView()
        //初始化navigationBar,添加按钮事件
        initView()
        // 添加下拉刷新
        initRefresh(scrollView: infoTableView, ApiMethod: self.api!, refreshHandler: {jsonobj in
            let bean = Mapper<sickListBean>().map(JSONObject: jsonobj)
            if bean?.code == 100 {
                self.header?.endRefreshing()
                if bean?.sickDataList == nil {
                    bean?.sickDataList = [SickBean]()
                }
                self.data = (bean?.sickDataList)!
                if self.data.count == 0{
                    //隐藏tableView,添加刷新按钮
                    self.showRefreshBtn()
                }
                let tableView = self.scrollView as! UITableView
                tableView.reloadData()
            }else {
                self.header?.endRefreshing()
                showToast(self.view, (bean?.msg!)!)
            }
        }, getMoreHandler: getMoreData)
        
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

    private func getMoreData() {
        let Provider = MoyaProvider<API>()
        Provider.request(self.api!) { result in
            switch result {
            case let .success(response):
                do {
                    let bean = Mapper<sickListBean>().map(JSONObject: try response.mapJSON())
                    if bean?.code == 100 {
                        self.footer?.endRefreshing()
                        if bean?.sickDataList?.count == 0{
                            showToast(self.view, "已经到底了")
                            return
                        }
                        self.footer?.endRefreshing()
                        self.data += (bean?.sickDataList)!
                        self.selectedPage += 1
                        let tableView = self.scrollView as! UITableView
                        tableView.reloadData()
                        
                    }else {
                        self.footer?.endRefreshing()
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
    
   
    
    
    
    //MARK: - action
    @objc func clickBtn(button:UIButton){
        switch button.tag {
        // 推荐病人
        case 10001:
            cleanButton()
            sortByPatientBtn.setTitleColor(UIColor.LightSkyBlue, for: .normal)
            //更新上拉刷新与加载
            api = API.listsicks(self.selectedPage, lat, lon)
            ApiMethod = api
            self.header?.beginRefreshing()
            showToast(self.view, "按照推荐病人排序")
        // 时间
        case 10002:
            cleanButton()
            sortByTimeBtn.setTitleColor(UIColor.LightSkyBlue, for: .normal)
            //更新上拉刷新与加载
            api = API.listsicksBytype(self.selectedPage, 1, lat, lon)
            ApiMethod = api
            self.header?.beginRefreshing()
            showToast(self.view, "按照时间排序")
        // 地点
        case 10003:
            cleanButton()
            sortByLocBtn.setTitleColor(UIColor.LightSkyBlue, for: .normal)
            //更新上拉刷新与加载
            api = API.listsicksBytype(self.selectedPage, 2, lat, lon)
            ApiMethod = api
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
