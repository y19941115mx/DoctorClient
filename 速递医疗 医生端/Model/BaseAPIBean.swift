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

class BaseBean<T:Mappable>:BaseAPIBean {
    var data: T?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
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

// 我的日程

class OrderBean: Mappable {
    var userloginpix:String?
    var userorderprice:Double? // 订单价格
    var docaddresslocation:String? // 地点（医院名）
    var userorderappointment: String? // 预约时间
    var usersickdesc:String? // 病情描述
    var usersickpic:String?
    var familyname: String? // 就诊人姓名
    var familyage:Int?
    var userorderid: Int = 0 //订单Id
    var userorderstatename: String? // 订单状态描述
    var userorderetime: String? // 订单时间
    
    var userorderdprice:Double? // 出诊价格
    var userordertprice:Double? //交通价格
    var userorderaprice:Double? // 住宿价格
    var userordereprice:Double? // 餐饮价格
    var userordertpricetypename:String?
    var userorderapricetypename:String?
    var userorderepricetypename:String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userorderetime <- map["userorderetime"]
        userloginpix <- map["userloginpix"]
        usersickpic <- map["usersickpic"]
        familyage <- map["familyage"]
        userorderdprice <- map["userorderdprice"]
        userordertprice <- map["userordertprice"]
        userorderaprice <- map["userorderaprice"]
        userordereprice <- map["userordereprice"]
        userordertpricetypename <- map["userordertpricetypename"]
        userorderapricetypename <- map["userorderapricetypename"]
        userorderepricetypename <- map["userorderepricetypename"]
        
        userorderappointment <- map["userorderappointment"]
        userorderprice <- map["userorderprice"]
        docaddresslocation <- map["docaddresslocation"]
        familyname <- map["familyname"]
        userorderid <- map["userorderid"]
        usersickdesc <- map["usersickdesc"]
        userorderstatename <- map["userorderstatename"]
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
    var usersickid:Int = 0
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
        usersickid <- map["usersickid"]
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

// 我的会诊 列表页
//"hospname": "安徽省安医大二附院",
// ordertotalhospprice
//"hosploginid": 14,
//"hosporderid": 62,
//"hosplevelname": "一级甲等",
//"hosphuanxinaccount": "hosp_14",
//"orderstime": "2017-12-21 上午",
//"hosploginpix": "http://oytv6cmyw.bkt.clouddn.com/20171103064014944735.jpg",

class ConsultationBean:Mappable {
    var hospname:String?
    var hosploginid:Int?
    var hosporderid:Int?
    var hosplevelname:String?
    var hosphuanxinaccount:String?
    var orderstime:String?
    var hosploginpix:String?
    var ordertotalhospprice:Double?
    
    var orderhospprice:Double?
    
    var orderhosptpricetypename:String?
    var orderhosptprice:Double?
    var orderhospapricetypename:String?
    var orderhospaprice:Double?
    var orderhospepricetypename:String?
    var orderhospeprice:Double?
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        orderhospprice <- map["orderhospprice"]
        orderhosptprice <- map ["orderhosptprice"]
        orderhosptpricetypename <- map["orderhosptpricetypename"]
        orderhospapricetypename <- map["orderhospapricetypename"]
        orderhospaprice <- map["orderhospaprice"]
        orderhospepricetypename <- map["orderhospepricetypename"]
        orderhospeprice <- map["orderhospeprice"]
        
        hospname <- map["hospname"]
        hosploginid <- map["hosploginid"]
        hosporderid <- map["hosporderid"]
        hosplevelname <- map["hosplevelname"]
        hosphuanxinaccount <- map["hosphuanxinaccount"]
        orderstime <- map["orderstime"]
        hosploginpix <- map["hosploginpix"]
        ordertotalhospprice <- map["ordertotalhospprice"]
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
    
    init(name:String,province:String,city:String, distinct:String,adress:String,lon:String,lat:String) {
        docaddresslocation = name
        docaddressprovince = province
        docaddresscity = city
        docaddressarea = distinct
        docaddressother = adress
        docaddresslon = lon
        docaddresslat = lat
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


// 我的 交易记录
class MineTradeBean:Mappable {
    var payorderid:Int?
    var paymodename:String? // 支付方式
    var paycreattime:String? // 时间
    var paytotalamount:Double? // 金额
    var paysendername:String? // 收款人
    var paystatename: String? // 订单状态描述
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        payorderid <- map["payorderid"]
        paymodename <- map["paymodename"]
        paycreattime <- map["paycreattime"]
        paytotalamount <- map["paytotalamount"]
        paysendername <- map["paysendername"]
        paystatename <- map["paystatename"]
    }
    
}

// 我的 通知
//"notificationwords": "六角恐龙医生接受了您的订单",
//"notificationid": 410,
//"notificationread": false,
//"notificationtitle": "等待确认",
//"notificationcreatetime": "2017-12-09 22:28:24"

class NotificationBean:Mappable {
    var notificationwords:String?
    var notificationid:Int?
    var notificationread:Bool?
    var notificationtitle:String?
    var notificationcreatetime:String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        notificationwords <- map["notificationwords"]
        notificationid <- map["notificationid"]
        notificationread <- map["notificationread"]
        notificationtitle <- map["notificationtitle"]
        notificationcreatetime <- map["notificationcreatetime"]
    }
    
}

// 医院信息
//"hospabs": "",
//"hospfeature": "",
//"hospname": "安徽第一人民医院",
//"hosplevelname": null,
//"hospadrother": "",
//"hosphuanxinaccount": "hosp_1",
//"hospadrlat": "",
//"hospadrprovince": "",
//"hospadrcity": "",
//"hosploginpix": "http://oytv6cmyw.bkt.clouddn.com/20171103064014944735.jpg",
//"hospadrarea": "",
//"hospadrlon": ""
class HospitalBean:Mappable {
    var hospname:String?
    var hosploginid:Int?
    var hosplevelname:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        hospname <- map["hospname"]
        hosploginid <- map["hosploginid"]
        hosplevelname <- map["hosplevelname"]
    }
    
    
}

