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
    let titles = [["我的简介"],["擅长疾病"]]
//    var info = "选择坐诊地点"
    var infos = [MineLocationBean]()
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let titleLable = cell.viewWithTag(1) as! UILabel
        titleLable.text = titles[indexPath.section][indexPath.row]
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
            break
            
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}
