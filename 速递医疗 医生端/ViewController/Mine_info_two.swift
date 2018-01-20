//
//  Mine_info_two.swift
//  速递医疗 医生端
//
//  Created by hongyiting on 2017/12/8.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit

class Mine_info_two: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var tableView: BaseTableView!
    let tableTitle = ["身份证照片","职称照片", "行医资格证照片","工作证照片","其他照片"]
    
    var tableData = ["", "", "", "", ""]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let title = self.tableTitle[indexPath.row]
        var info = ""
        if tableData.count != 0 {
            info = tableData[indexPath.row]
        }
        let label_title = cell.viewWithTag(1) as! UILabel
        let label_info = cell.viewWithTag(2) as! UILabel
        if info != "" {
            label_info.text = "已上传"
        }
        label_title.text = title
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let msg = user_default.typename.getStringValue()
        if msg == "审核中" || msg == "已审核" {
            reviewBtn.isHidden = true
        }else {
            reviewBtn.isHidden = false
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NetWorkUtil.init(method: .getsecondinfo).newRequest(successhandler: { (bean, json) in
            let data = json["data"]
            let IdCard = data["doccardphoto"].stringValue
            let workCard = data["docworkcardphoto"].stringValue
            let qualCard = data["docqualphoto"].stringValue
            let titleCard = data["doctitlephoto"].stringValue
            let otherPhoto = data["docotherphoto"].stringValue
            self.tableData = [IdCard, titleCard, qualCard, workCard, otherPhoto]
            self.tableView.reloadData()
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditPhoto" {
            let row = self.tableView.indexPathForSelectedRow?.row
            let string = self.tableData[row!]
            let vc = segue.destination as! Mine_info_photo
            vc.type = row! + 1
            if string != "" {
                var images = [UIImage]()
                for str in StringUTil.splitImage(str: string) {
                    images.append(ImageUtil.URLToImg(url: URL.init(string: str)!))
                }
                vc.imgResource = images
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func updateInfo(_ sender: Any) {
        NetWorkUtil.init(method: .reviewinfo).newRequest(successhandler: { (bean, json) in
            
            self.dismiss(animated: false, completion: nil)
            Toast(bean.msg!)
        })
    }
    

}
