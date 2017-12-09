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

class BaseListBean<T:Mappable>:BaseAPIBean {
    var dataList:[T]?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        dataList <- map["data"]
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

// 我的病人: 我选择的
class mypatient_check:Mappable {
    var usersickid:Int = 0
    var preorderid:Int = 0
    var userloginpix:String?
    var userhuanxinaccount:String?
    var familyname:String?
    var familymale:String?
    var familyage:Int = 0
    var preordertime:String?
    var usersickdesc:String?
    var preorderprice:Double = 0.0
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        usersickid <- map["usersickid"]
        preorderid <- map["preorderid"]
        userloginpix <- map["userloginpix"]
        userhuanxinaccount <- map["userhuanxinaccount"]
        familyage <- map["familyage"]
        familymale <- map["familymale"]
        familyname <- map["familyname"]
        preordertime <- map["preordertime"]
        usersickdesc <- map["usersickdesc"]
        preorderprice <- map["preorderprice"]
    }
    
}

// 我的病人 选择我的
class mypatient_checked:Mappable {
    var userorderid:Int = 0
    var userloginpix:String?
    var userhuanxinaccount:String?
    var familyname:String?
    var familymale:String?
    var familyage:Int = 0
    var userorderptime:String?
    var usersickdesc:String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userorderid <- map["userorderid"]
        userloginpix <- map["userloginpix"]
        userhuanxinaccount <- map["userhuanxinaccount"]
        familyage <- map["familyage"]
        familymale <- map["familymale"]
        familyname <- map["familyname"]
        userorderptime <- map["userorderptime"]
        usersickdesc <- map["usersickdesc"]

    }
    
}

// 我的 地点信息

class MineLocationBean:Mappable {
    var docaddressid = 0
    var docaddresslocation:String?
    var docaddressprovince:String?
    var docaddresscity:String?
    var docaddressarea:String?
    var docaddressother:String?
    var docaddresslon:String?
    var docaddresslat:String?
    var docloginid = 0
    var docaddresstype = false
    var docaddresschecked = false
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        docaddressid <- map["docaddressid"]
        docaddresslocation <- map["docaddresslocation"]
        docaddressprovince <- map["docaddressprovince"]
        docaddresscity <- map["docaddresscity"]
        docaddressarea <- map["docaddressarea"]
        docaddressother <- map["docaddressother"]
        docaddresslon <- map["docaddresslon"]
        docaddresslat <- map["docaddresslat"]
        docloginid <- map["docloginid"]
        docaddresstype <- map["docaddresstype"]
        docaddresschecked <- map["docaddresschecked"]
    }
    
}

// 我的 日程信息

class MineCalendarBean:Mappable {
    var doccalendarid = 0
    var doccalendaradressid = 0
    var docaddresslocation:String?
    var doccalendarday:String?
    var doccalendaraffair:String?
    var doccalendartime:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        doccalendarid <- map["doccalendarid"]
        doccalendaradressid <- map["doccalendaradressid"]
        docaddresslocation <- map["docaddresslocation"]
        doccalendarday <- map["doccalendarday"]
        doccalendaraffair <- map["doccalendaraffair"]
        doccalendartime <- map["doccalendartime"]
    }
    
    
}





