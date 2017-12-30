//
//  Mine_add_hospital.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit


class Mine_add_hospital: BaseRefreshController<MineLocationBean>, AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate {
    var search: AMapSearchAPI!
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MineAddHospitalTableViewCell
        if cell == nil {
            cell =  Bundle.main.loadNibNamed("MineAddHospitalTableViewCell", owner: nil, options: nil)?.last as? MineAddHospitalTableViewCell
        }
        let bean = data[indexPath.row]
        cell?.updateViews(vc: self, data: bean)
        return cell!
    }
    

    @IBOutlet weak var tabelView: BaseTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化POI
        search = AMapSearchAPI()
        search.delegate = self
        initNoFooterRefresh(scrollView: tabelView, ApiMethod: .getalladdress, isTableView: true)
        self.header?.beginRefreshing()
        
    }

    //MARK: - Action
    
    func searchPOI(withKeyword keyword: String?) {
        
        if keyword == nil || keyword! == "" {
            return
        }
        
        let request = AMapPOIKeywordsSearchRequest()
        request.keywords = keyword
        request.requireExtension = true
//        request.city = "北京"
        search.aMapPOIKeywordsSearch(request)
    }
    
    // 添加医院
    @IBAction func addAction(_ sender: Any) {
        let textField = UITextField()
        textField.placeholder = "输入地址关键字"
        
        AlertUtil.popTextFields(vc: self, title: "请输入信息", textfields: [textField]) { (textfields) in
            let text = textfields[0].text ?? ""
            if text == "" {
                Toast("输入信息不能为空")
            }else {
                self.searchPOI(withKeyword: text)
            }
        }
    }
    
    @IBAction func backAcion(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK: - AMapSearchDelegate
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        Toast("Error:\(error)")
    }
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        if response.count == 0 {
            showToast(self.view, "未查询到相关地址")
            return
        }
        var POIS = [MineLocationBean]()
        for aPOI in response.pois {
            let bean = MineLocationBean.init(name: aPOI.name, province: aPOI.province, city: aPOI.city, distinct: aPOI.district, adress: aPOI.address, lon: "\(aPOI.location.longitude)", lat: "\(aPOI.location.latitude)")
            POIS.append(bean)
        }
        var btns = [String]()
        if POIS.count != 0 {
            for item in POIS {
                btns.append(item.docaddresslocation!)
            }
        }
        AlertUtil.popMenu(vc: self, title: "选择地点", msg: "", btns: btns) { (str) in
            let index = btns.index(of: str)
            let bean = POIS[index!]
            NetWorkUtil.init(method: API.addaddress(bean.docaddresslocation!, bean.docaddressprovince!, bean.docaddresscity!, bean.docaddressarea!, bean.docaddressother!, bean.docaddresslon!, bean.docaddresslat!)).newRequest(handler: { (bean, json) in
                if bean.code == 100 {
                    self.refreshData()
                }
                showToast(self.view, bean.msg!)
            })
        }
        
       
    }
    
}
