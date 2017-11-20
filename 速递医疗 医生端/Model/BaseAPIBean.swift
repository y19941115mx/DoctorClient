//
//  BaseAPIBean.swift
//  速递医疗 医生端
//
//  Created by admin on 2017/10/31.
//  Copyright © 2017年 victor. All rights reserved.
//

import ObjectMapper

class BaseAPIBean:Mappable {
    var msg: String?
    var code: Int = 0
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        msg <- map["msg"]
        code <- map["code"]
    }
}

class BaseListBean<T>:BaseAPIBean {
    var dataList:[T]?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        dataList <- map["data"]
    }
}

class DoctorListBean:BaseAPIBean {
    var doctorDataList:[DoctorBean]?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        doctorDataList <- map["data"]
    }
}

class DoctorBean:Mappable {
    var dept:String?
    var hospital:String?
    var allday: Bool = false
    var docId: Int = 0
    var distance:Int = 0
    var primary:String?
    var pix:String?
    var name:String?
    var hospitalLevel:String?
    var docLevel:String?
    var docexpert:String?
    var preordertypename:String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        dept <- map["docseconddept"]
        hospital <- map["dochosp"]
        allday <- map["docallday"]
        docId <- map["docloginid"]
        distance <- map["distance"]
        primary <- map["docprimarydept"]
        pix <- map["docloginpix"]
        name <- map["docname"]
        hospitalLevel <- map["hosplevel"]
        docLevel <- map["doctitle"]
        docexpert <- map["docexpert"]
        preordertypename <- map["preordertypename"]
    }
}

class OrderListBean:BaseAPIBean {
    var OrderDataList:[OrderBean]?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        OrderDataList <- map["data"]
    }
}

class OrderBean: Mappable {
    var userorderappointment: String? // 订单预约医生时间
    var familyname: String? // 用户姓名
    var userorderid: Int = 0 //订单Id
    var usersickdesc: String? // 病情描述
    var userorderstateid: Int = 0 // 订单状态
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userorderappointment <- map["userorderappointment"]
        familyname <- map["familyname"]
        userorderid <- map["userorderid"]
        usersickdesc <- map["usersickdesc"]
        userorderstateid <- map["userorderstateid"]
    }
}



class familyListBean:BaseAPIBean {
    var familyDataList: [familyBean]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        familyDataList <- map["data"]
    }
    
}

class familyBean:Mappable {
    var familyid: Int = 0
    var familyname: String?
    var familymale: String?
    var familyage: Int = 0
    var userloginid:Int = 0
    var familytype:Bool = false
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        familyid <- map["familyid"]
        familyname <- map["familyname"]
        familymale <- map["familymale"]
        familyage <- map["familyage"]
        userloginid <- map["userloginid"]
        familytype <- map["familytype"]
    }
    
}

// 首页病情
class sickListBean:BaseAPIBean {
    
    var sickDataList: [SickBean]?
    required init?(map: Map) {
        super.init(map: map)
    }
    override func mapping(map: Map) {
        super.mapping(map: map)
        sickDataList <- map["data"]
    }
    
}

class SickBean:Mappable {
    var usersickid: Int = 0 // 病情Id
    var usersickptime:String? // 发布时间
    var distance:String? // 距离
    var userloginpix:String? // 用户头像
    var familymale:String? // 亲属性别
    var familyname: String? // 亲属姓名
    var familyage: Int = 0 // 亲属年龄
    var userhuanxinaccount:String? // 环信账号
    var usersickdesc: String? // 病情描述
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        familymale <- map["familymale"]
        familyname <- map["familyname"]
        userhuanxinaccount <- map["userhuanxinaccount"]
        usersickptime <- map["usersickptime"]
        usersickid <- map["usersickid"]
        usersickdesc <- map["usersickdesc"]
        familyage <- map["familyage"]
        userloginpix <- map["userloginpix"]
        distance <- map["distance"]
    }
    
}

// 病情详情
class sickDetailBean: BaseAPIBean {
    var sickDetail: sickDetail?
    required init?(map: Map) {
        super.init(map: map)
    }
    override func mapping(map: Map) {
        super.mapping(map: map)
        sickDetail <- map["data"]
    }
}



//病情图片 usersickpic
//病情一级部门 usersickprimarydept
//病情二级部门 usersickseconddept


class sickDetail:SickBean {
    var usersickpic:String?
    var usersickprimarydept:String?
    var usersickseconddept:String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        usersickpic <- map["usersickpic"]
        usersickprimarydept <- map["usersickprimarydept"]
        usersickseconddept <- map["usersickseconddept"]
    }
    

}



