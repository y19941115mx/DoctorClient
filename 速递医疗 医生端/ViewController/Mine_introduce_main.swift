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
    var infos = [String]()
    
    
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
            performSegue(withIdentifier: "SetDate", sender: self)
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsetsMake(-35+10, 0, 0, 0)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NetWorkUtil<BaseListBean<MineLocationBean>>.init(method: .getalladdress).newRequestWithoutHUD { (bean, json) in
            let datas = bean.dataList
            if datas != nil {
                for data in datas! {
                    if data.docaddresschecked {
                        self.info = data.docaddresslocation!
                    }
                    self.infos.append(data.docaddresslocation!)
                }
            }
            showToast(self.view, bean.msg!)
        }
    }

   

}
