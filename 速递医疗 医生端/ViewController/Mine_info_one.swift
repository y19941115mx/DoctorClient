//
//  Mine_info_one.swift
//  速递医疗 医生端
//
//  Created by hongyiting on 2017/12/7.
//  Copyright © 2017年 victor. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit

class Mine_info_one: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var tableView: BaseTableView!
    var tableData:[Any] = ["请输入真实的中文姓名","请选择昵称","请输入真实的身份证号","请选择性别","请输入年龄","请输入常驻医院", "请选择医院级别", "请选择所属科室", false]
    // 科室信息
    var proIndex:Int = 0
    var oneDepart = ""
    var twoDepart = ""
    let deptPicker = UIPickerView()
    let myToolBar = UIToolbar()
    var mSwitch:UISwitch?
    
    // MARK: - UItableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == tableData.count - 1 {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
            let label_title = cell2.viewWithTag(1) as! UILabel
            let mySwitch = cell2.viewWithTag(2) as! UISwitch
            self.mSwitch = mySwitch
            label_title.text = "是否全天"
            mySwitch.isOn = tableData[indexPath.row] as! Bool
            return cell2
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var title = ""
        switch indexPath.row {
        case 0:
            title = "姓名"
        case 1:
            title = "职称"
        case 2:
            title = "身份证"
        case 3:
            title = "性别"
        case 4:
            title = "年龄"
        case 5:
            title = "所属医院"
        case 6:
            title = "医院级别"
        case 7:
            title = "科室"
        default:
            title = ""
        }
        let info = tableData[indexPath.row]
        let label_title = cell.viewWithTag(1) as! UILabel
        let label_info = cell.viewWithTag(2) as! UILabel
        label_info.text = "\(info)"
        label_title.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let textField = UITextField()
            textField.placeholder = "请输入你的姓名"
            textField.keyboardType = .namePhonePad
            AlertUtil.popTextFields(vc: self, title: "输入内容", textfields: [textField], okhandler: { (textFields) in
                self.tableData[indexPath.row] = textFields[0].text ?? ""
                tableView.reloadRows(at: [indexPath], with: .none)
            })
        case 1:
            AlertUtil.popMenu(vc: self, title: "选择职称", msg: "", btns: ["住院医师", "主治医师", "副主任医师", "主任医师"], handler: { (str) in
                self.tableData[indexPath.row] = str
                tableView.reloadRows(at: [indexPath], with: .none)
            })
        case 2:
            let textField = UITextField()
            textField.placeholder = "请输入你的身份证"
            textField.keyboardType = .namePhonePad
            AlertUtil.popTextFields(vc: self, title: "输入内容", textfields: [textField], okhandler: { (textFields) in
                self.tableData[indexPath.row] = textFields[0].text ?? ""
                tableView.reloadRows(at: [indexPath], with: .none)
            })
        case 3:
            AlertUtil.popMenu(vc: self, title: "选择职称", msg: "", btns: ["男", "女"], handler: { (str) in
                self.tableData[indexPath.row] = str
                tableView.reloadRows(at: [indexPath], with: .none)
            })
        case 4:
            let textField = UITextField()
            textField.placeholder = "请输入你的年龄"
            textField.keyboardType = .numberPad
            AlertUtil.popTextFields(vc: self, title: "输入内容", textfields: [textField], okhandler: { (textFields) in
                self.tableData[indexPath.row] = textFields[0].text ?? ""
                tableView.reloadRows(at: [indexPath], with: .none)
            })
        case 5:
            let textField = UITextField()
            textField.placeholder = "请输入医院名称"
            AlertUtil.popTextFields(vc: self, title: "输入内容", textfields: [textField], okhandler: { (textFields) in
                self.tableData[indexPath.row] = textFields[0].text ?? ""
                tableView.reloadRows(at: [indexPath], with: .none)
            })
        case 6:
            AlertUtil.popMenu(vc: self, title: "选择医院级别", msg: "", btns: ["一级甲等", "一级乙等","一级丙等","二级甲等","二级乙等","二级丙等","三级甲等","三级乙等","三级丙等"], handler: { (str) in
                self.tableData[indexPath.row] = str
                tableView.reloadRows(at: [indexPath], with: .none)
            })
        case 7:
            showUIPickView()
        case 8:
            self.mSwitch?.isOn = !(self.mSwitch?.isOn)!
            self.tableData[indexPath.row] = self.mSwitch?.isOn ?? false
            tableView.reloadRows(at: [indexPath], with: .none)
            
        default:
            dPrint(message: "error")
        }
    }
    
    // MARK: - UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //判断当前是第几列
        if (component == 0) {
            // 一级科室的数量
            return APPLICATION.departData.keys.count
        }else{
            //二级科室的数量
            let key = Array(APPLICATION.departData.keys)[proIndex]
            return (APPLICATION.departData[key]?.count)!
        }
    }
    
    //MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        if (component == 0) {
            // 一级科室
            return Array(APPLICATION.departData.keys)[row]
        }else{
            //取出选中的二级科室
            let key = Array(APPLICATION.departData.keys)[proIndex]
            return APPLICATION.departData[key]?[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if (component == 0) {
            //选中第一列
            proIndex = pickerView.selectedRow(inComponent: 0)
            self.deptPicker.reloadComponent(1)
        }
        //获取选中的一级科室
        let oneDepart = Array(APPLICATION.departData.keys)[proIndex]
        //获取选中的二级科室
        let twoDeparts = APPLICATION.departData[oneDepart]
        if  twoDeparts?.count != 0{
            let row = pickerView.selectedRow(inComponent: 1)
            self.oneDepart = oneDepart
            self.twoDepart = (twoDeparts?[row])!
            self.tableData[7] = "\(oneDepart) \(twoDeparts?[row] ?? "")"
        }else{
            self.oneDepart = oneDepart
            self.tableData[7] = oneDepart
        }
        tableView.reloadRows(at: [IndexPath.init(row: 7, section: 0)], with: .none)
        
    }
    
    // MARK: - view
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 加载数据
        NetWorkUtil.init(method: .getfirstinfo).newRequest { (bean, json) in
            Toast(bean.msg!)
            let data = json["data"]
            if data != JSON.null {
                let name = data["docname"].string ?? self.tableData[0]
                let title = data["doctitle"].string ?? self.tableData[1]
                let cardNum = data["doccardnum"].string ?? self.tableData[2]
                let sex = data["docmale"].string ?? self.tableData[3]
                let age = data["docage"].int ?? self.tableData[4]
                let hospital = data["dochosp"].string ?? self.tableData[5]
                let level = data["hosplevel"].string ?? self.tableData[6]
                var depart = self.tableData[7]
                if data["docprimarydept"].string != nil {
                    depart = "\(data["docprimarydept"].stringValue) - \(data["docseconddept"].stringValue)"
                }
                let flag = data["docallday"].boolValue
                
                self.tableData = [name, title, cardNum, sex, age, hospital, level, depart, flag]
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    @IBAction func click_save(_ sender: UIButton) {
        NetWorkUtil<BaseAPIBean>.init(method: .updatefirstinfo(tableData[0] as! String, tableData[1] as! String, tableData[2] as! String, tableData[3] as! String, tableData[4] as! String, tableData[5] as! String, tableData[6] as! String,self.oneDepart, self.twoDepart,  tableData[8] as! Bool)).newRequest { (bean, json) in
            showToast(self.view, bean.msg!)
        }
    }
    
    @objc func clickBtn(button:UIButton){
        // 选择科室
        self.deptPicker.isHidden = true
        self.myToolBar.isHidden = true
    }
    
    // 显示pickerView
    private func showUIPickView() {
        self.deptPicker.isHidden = false
        self.myToolBar.isHidden = false
        self.view.addSubview(self.deptPicker)
        deptPicker.snp.makeConstraints { (make) in
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
            make.bottom.equalTo(self.deptPicker.snp.top)
        }
        let finishBtn = UIBarButtonItem(title: "完成", style: .done, target:self, action: #selector(self.clickBtn(button:)))
        myToolBar.setItems([finishBtn], animated: false)
        deptPicker.delegate = self
        deptPicker.dataSource = self
        deptPicker.backgroundColor = UIColor.white
    }
    
}
