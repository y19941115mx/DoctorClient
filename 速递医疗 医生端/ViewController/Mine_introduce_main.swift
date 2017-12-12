//
//  Mine_introduce_main.swift
//  速递医疗 医生端
//
//  Created by hongyiting on 2017/12/8.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Mine_introduce_main: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: BaseTableView!
    let titles = [["我的简介"],["擅长疾病"],["出诊计划","默认出诊地点","常用地址"]]
    var info = "选择坐诊地点"
    var infos = [MineLocationBean]()
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 3
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let titleLable = cell.viewWithTag(1) as! UILabel
        let infoLabel = cell.viewWithTag(2) as! UILabel
        titleLable.text = titles[indexPath.section][indexPath.row]
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                infoLabel.text = "编辑出诊计划"
            }else if indexPath.row == 1 {
                infoLabel.text = info
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let vc = UIStoryboard.init(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "EditSick") as! EditViewController
            self.present(vc, animated: false, completion: nil)
        case 1:
            let vc = UIStoryboard.init(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "EditSick") as! EditViewController
            vc.flag = 1
            self.present(vc, animated: false, completion: nil)
        default:
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "SetDate", sender: self)
            case 1:
                var btns = [String]()
                for item in infos {
                    btns.append(item.docaddresslocation!)
                }
                AlertUtil.popMenu(vc: self, title: "设置默认出诊地点", msg: "", btns: btns, handler: { (str) in
                    let index = btns.index(of: str)
                    let addressidid = self.infos[index!].docaddressid
                    NetWorkUtil.init(method: API.setaddress(addressidid)).newRequest(handler: { (bean, josn) in
                        showToast(self.view, bean.msg!)
                    })
                })
            default:
                dPrint(message: "error")
            }
            
            
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NetWorkUtil<BaseListBean<MineLocationBean>>.init(method: .getalladdress).newRequestWithoutHUD { (bean, json) in
            let datas = bean.dataList
            if datas != nil {
                for data in datas! {
                    if data.docaddresschecked {
                        self.info = data.docaddresslocation!
                        self.tableView.reloadRows(at: [IndexPath.init(row: 1, section: 2)], with: .none)
                    }
                    self.infos.append(data)
                }
            }
            showToast(self.view, bean.msg!)
        }
    }

   

}
