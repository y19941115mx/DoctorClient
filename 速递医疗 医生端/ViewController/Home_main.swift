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

class Home_main:BaseRefreshController<SickBean>, UITableViewDataSource{
    
    @IBOutlet weak var infoTableView: UITableView!
    
    @IBOutlet weak var sortByPatientBtn: UIButton!
    
    @IBOutlet weak var sortByTimeBtn: UIButton!
    
    @IBOutlet weak var sortByLocBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavTitle(title: "首页")
        //初始化navigationBar,添加按钮事件
        initView()
        // 添加下拉刷新
        initRefresh(scrollView: infoTableView, ApiMethod: .listsicks(self.selectedPage, "0", "0"), refreshHandler: {jsonobj in
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
        timeLabel.text = StringUTil.getComparedTimeStr(str: result.usersickptime!)
        descLabel.text = result.usersickdesc
        ImageUtil.setImage(path: result.userloginpix!, imageView: patientImg)
        return cell
    }
    
    // MARK: - private method
    private func initView(){
        sortByLocBtn.addTarget(self, action: #selector(Home_main.clickBtn(button:)), for: .touchUpInside)
        sortByTimeBtn.addTarget(self, action: #selector(Home_main.clickBtn(button:)), for: .touchUpInside)
        sortByPatientBtn.addTarget(self, action: #selector(Home_main.clickBtn(button:)), for: .touchUpInside)
    }
    
    private func cleanButton(){
        sortByLocBtn.setTitleColor(UIColor.black, for: .normal)
        sortByTimeBtn.setTitleColor(UIColor.black, for: .normal)
        sortByPatientBtn.setTitleColor(UIColor.black, for: .normal)
    }

    private func getMoreData() {
        let Provider = MoyaProvider<API>()
        Provider.request(API.listsicks(selectedPage, "0", "0")) { result in
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
            sortByPatientBtn.setTitleColor(UIColor.APPColor, for: .normal)
        // 时间
        case 10002:
            cleanButton()
            sortByTimeBtn.setTitleColor(UIColor.APPColor, for: .normal)
            AlertUtil.popMenu(vc: self, title: "选择性别", msg: "选择性别", btns: ["男","女"], handler: {value in
                dPrint(message: value)
            })
        // 地点
        case 10003:
            cleanButton()
            sortByLocBtn.setTitleColor(UIColor.APPColor, for: .normal)
            
        default:
            showToast(self.view, "error")
        }
    
    }
    //MARK: - navigation Methond
    @IBAction func unwindToHome(sender: UIStoryboardSegue){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
//            let SelectedIndexPath = infoTableView.indexPathForSelectedRow
//            let patient = data[SelectedIndexPath!.row]
//            let vc = segue.destination as! PatientDetailViewController
//            vc.patientBean = patient
        }
    }
}
