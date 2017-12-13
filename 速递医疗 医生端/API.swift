//
//  WeChatAPI.swift


import Foundation
import Moya

// 创建请求
public enum API {
    case doclogin(String, String) // 登录
    case docregister(String, String, String) // 注册
    case updatechannelid(String)
    case huanxinregister // 环信注册
    case getmsgcode(String)  // 发送验证码
    case phonetest(String) //验证短信验证码
    case updatepix(Data) // 上传头像
    case listsicks(Int, String, String) // 获取首页推荐病情数据
    case listsicksBytype(Int, Int, String, String) //  首页分类显示
    case getsickdetail(Int) // 获取病情详细信息
    case editpassword(String, String, String) // 重置密码
    case exit // 退出登录
    case graborder(Int, Double) // 医生抢单
    // 我的病人
    case listgraborders(Int) // 获取我选择的病人
    case listordertoconfirm(Int) // 获取选择我的病人
    case cancelgraborder(Int) // 取消我选择的病人
    case refuseorder(Int, Int) // 取消选择我的病人, 后面参数不为0时，推荐给其他医生
    case getdoctorbyname(String) // 根据名字获取医生
    case confirmorder(Int,Double,Int,Double,Int,Double,Int,Double) // 确认选择我的病人
    
    // 我的日程
    case getorder(Int, Int) // 获取我的日程 1 待确定 2 正在进行
    case cancelorder(Int) // 取消 待确认的订单
    case finishorder(Int, Bool) // 结束 进行中的订单
    
    // 我的会诊
    case listconsultation(Int, Int) // 获取我的会诊 1会诊申请，2 待确认会诊,3为进行中的会诊,4为已完成的会诊，5为历史会诊
    case cancelconsultation(Int) // 取消会诊
    case getconsultationdetail(Int) // 获取会诊详情
    case confirmconsultation(Int,Double,Int,Double,Int,Double,Int,Double) //确认会诊
    
    
    // 我的
    case getfirstinfo //获取个人信息 第一页
    case updatefirstinfo(String, String, String, String, String, String, String, String, String, Bool) //更新个人信息 第一页
    case getsecondinfo // 获取个人信息 第二页
    case updatesecondinfo(Int, [Data]) // 更新个人信息 第二页 type 1为身份证照片，2为职称照片，3为行医资格证照片，4为工作证照片，5为其他照片
    case reviewinfo // 提交审核
    
    case getinfo // 我的介绍 获取简介和擅长疾病
    case updateintroduce(String) // 更新我的介绍
    case updateexpert(String) // 更新我的擅长
    case getalladdress // 我的介绍 获取全部常用地址
    case addaddress(String, String, String, String, String, String, String) // 我的介绍 添加常用地址
    case deleteaddress(Int) // 删除常用地址
    case setaddress(Int) // 我的介绍 设置默认出诊地点
    case addcalendar(String, String,String, Int) // 我的介绍 添加坐诊计划
    case deletecalendar(Int)  // 删除坐诊计划
    case getcalendar(Int) // 获取日程表
    
    case listhistoryorder(Int) // 获取历史订单
    case getbalance //获取我的钱包
    case listtraderecord(Int) // 获取交易记录
    
    case listreceivenotification(Int) // 获取我的消息
    case getorderdetail(Int) // 读取消息具体信息
    case updateallnotificationtoread //将所有消息置为已读
    case updatenotificationtoread(Int) //将单个消息置为已读
    case deleteallreceivenotification // 删除收到的所有消息
    
    case getalipayaccount // 获取支付宝账号
    case updatealipayaccount(String) // 修改支付宝账号
    
    
    
}
// 配置请求
extension API: TargetType {
    public var baseURL: URL { return URL(string: StaticClass.BaseApi)! }
    public var path: String {
        switch self {
        case .doclogin:
            return "/doclogin"
        case .docregister:
            return "/docregister"
        case .huanxinregister:
            return "/huanxinregister"
        case .updatechannelid:
            return "/updatechannelid"
        case .getmsgcode:
            return "/getmsgcode"
        case .phonetest:
            return "/phonetest"
        case .listsicks:
            return "/listsicks"
        case .updatepix:
            return "/updatepix"
        case .listsicksBytype:
            return "/listsicks"
        case .getsickdetail:
            return "/getsickdetail"
        case .editpassword:
            return "/editpassword"
        case .exit:
            return "/exit"
        case .graborder:
            return "/graborder"
        case .listgraborders:
            return "/listgraborders"
        case .listordertoconfirm:
            return "/listordertoconfirm"
        case .cancelgraborder:
            return "/cancelgraborder"
        case .refuseorder:
            return "/refuseorder"
        case .confirmorder:
            return "/confirmorder"
        case .getorder:
            return "/getorder"
        case .finishorder:
            return "/finishorder"
        case .listconsultation:
            return "/listconsultation"
        case .cancelconsultation:
            return "/cancelconsultation"
        case .getconsultationdetail:
            return "/getconsultationdetail"
        case .confirmconsultation:
            return "/confirmconsultation"
        case .getfirstinfo:
            return "/getfirstinfo"
        case .updatefirstinfo:
            return "/updatefirstinfo"
        case .getsecondinfo:
            return "/getsecondinfo"
        case .updatesecondinfo:
            return "/updatesecondinfo"
        case .reviewinfo:
            return "/reviewinfo"
        case .getinfo:
            return "/getinfo"
        case .getalladdress:
            return "/getalladdress"
        case .setaddress:
            return "/setaddress"
        case .addcalendar:
            return "/addcalendar"
        case .listhistoryorder:
            return "/listhistoryorder"
        case .getbalance:
            return "/getbalance"
        case .listreceivenotification:
            return "/listreceivenotification"
        case .getorderdetail:
            return "/getorderdetail"
        case .getalipayaccount:
            return "/getalipayaccount"
        case .updatealipayaccount:
            return "/updatealipayaccount"
        case .getdoctorbyname:
            return "/getdoctorbyname"
        case .cancelorder:
            return "/cancelorder"
        case .updatenotificationtoread:
            return "/updatenotificationtoread"
        case .updateallnotificationtoread:
            return "/updateallnotificationtoread"
        case .updateexpert:
            return "/updateinfo"
        case .updateintroduce:
            return "/updateinfo"
        case .deletecalendar(_):
            return "/deletecalendar"
        case .getcalendar(_):
            return "/getcalendar"
        case .listtraderecord:
            return "/listtraderecord"
        case .deleteallreceivenotification:
            return "/deleteallreceivenotification"
        case .addaddress:
            return "/addaddress"
        case .deleteaddress:
            return "/deleteaddress"
        }
    }
    public var method: Moya.Method {
        return .post
    }
    
    
    public var sampleData: Data {
            return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
    }
    public var task: Moya.Task {
        
        switch self {
        case .doclogin(let phone, let pwd):
            return  .requestParameters(parameters: ["docloginphone":phone, "docloginpwd": pwd, "doclogindev":2], encoding: URLEncoding.default)
        case .docregister(let phone, let pwd, let code):
            return .requestParameters(parameters: ["docloginphone":phone, "docloginpwd":pwd, "code":code], encoding: URLEncoding.default)
        case .huanxinregister:
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "docloginpwd":user_default.password.getStringValue()!], encoding: URLEncoding.default)
        case .updatechannelid(let id):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "channelid":id], encoding: URLEncoding.default)
        case .getmsgcode(let phone):
            return .requestParameters(parameters: ["docloginphone":phone], encoding: URLEncoding.default)
        case .phonetest(let phone):
            return .requestParameters(parameters: ["docloginphone":phone], encoding: URLEncoding.default)
        case .listsicks(let page, let lat, let lon):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "page":page, "lat":lat, "lon":lon], encoding: URLEncoding.default)

        case .updatepix(let data):
        return .uploadCompositeMultipart([MultipartFormData.init(provider: .data(data), name: "docloginpix", fileName: "photo.jpg", mimeType:"image/png")], urlParameters: ["docloginid": user_default.userId.getStringValue()!])

        case .listsicksBytype(let page, let type, let lat, let lon):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "page":page, "lat":lat, "lon":lon, "type":type], encoding: URLEncoding.default)
        case .getsickdetail(let sickId):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "usersickid": sickId], encoding: URLEncoding.default)
        case .editpassword(let phone, let pass, let code):
            return .requestParameters(parameters: ["docloginphone":phone, "docloginpwd":pass, "code":code], encoding: URLEncoding.default)
        case .exit:
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!], encoding: URLEncoding.default)
        case .graborder(let sickId, let price):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "usersickid":sickId, "preorderprice": price], encoding: URLEncoding.default)
        case .listgraborders(let page):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "page": page], encoding: URLEncoding.default)
        case .listordertoconfirm(let page):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "page": page], encoding: URLEncoding.default)
        case .cancelgraborder(let preorderid):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!,"preorderid":preorderid], encoding: URLEncoding.default)
        case .refuseorder(let orderId, let doctorId):
            if doctorId == 0 {
                return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "userorderid":orderId], encoding: URLEncoding.default)
            }else{
                return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "userorderid":orderId, "redocloginid":doctorId], encoding: URLEncoding.default)
            }
            
        case .confirmorder(let orderId,let orderPrice, let trafficType, let trafficPrice, let hotelType, let hotelPrice, let foodType, let foodPrice):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "userorderid":orderId, "userorderdprice":orderPrice, "userordertpricetype":trafficType, "userordertprice":trafficPrice,"userorderapricetype":hotelType, "userorderaprice":hotelPrice, "userorderepricetype":foodType, "userordereprice":foodPrice], encoding: URLEncoding.default)
        case .getorder(let page, let type):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "page":page, "type":type], encoding: URLEncoding.default)
        case .finishorder(let orderId, let ishospital):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "userorderid":orderId, "userorderhstate":ishospital], encoding: URLEncoding.default)
        case .listconsultation(let page, let type):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "page":page, "type":type], encoding: URLEncoding.default)
        case .cancelconsultation(let orderId):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "hosporderid":orderId], encoding: URLEncoding.default)
        case .getconsultationdetail(let orderId):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "hosporderid":orderId], encoding: URLEncoding.default)
        case .confirmconsultation(let orderId,let orderPrice, let trafficType, let trafficPrice, let hotelType, let hotelPrice, let foodType, let foodPrice):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "hosporderid":orderId, "orderdoctorprice":orderPrice, "orderdoctortpricetype":trafficType, "orderdoctortprice":trafficPrice,"orderdoctorapricetype":hotelType, "orderdoctoraprice":hotelPrice, "orderdoctorepricetype":foodType, "orderdoctoreprice":foodPrice], encoding: URLEncoding.default)
        case .getfirstinfo:
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!], encoding: URLEncoding.default)
//            hosplevel dochosp
        case .updatefirstinfo(let docname, let doctitle , let doccardnum, let docmale, let docage, let dochosp, let hosplevel, let docprimarydept, let docseconddept, let docallday):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "dochosp":dochosp, "hosplevel":hosplevel, "docallday":docallday, "docage":docage,"docmale":docmale, "doccardnum":doccardnum, "docname":docname, "docprimarydept":docprimarydept, "docseconddept":docseconddept, "doctitle":doctitle], encoding: URLEncoding.default)
        case .getsecondinfo:
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!], encoding: URLEncoding.default)
        case .updatesecondinfo(let type, let datas):
            var formDatas = [MultipartFormData]()
            for (i, data) in datas.enumerated() {
                let formData = MultipartFormData.init(provider: .data(data), name: "picture", fileName: "picture\(i).jpg", mimeType: "image/png")
                formDatas.append(formData)
            }
            return .uploadCompositeMultipart(formDatas, urlParameters: ["docloginid": user_default.userId.getStringValue()!, "type":type])
        case .reviewinfo:
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!], encoding: URLEncoding.default)
        case .getdoctorbyname(let name):
            return .requestParameters(parameters: ["docname":name], encoding: URLEncoding.default)
        case .cancelorder(let orderId):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!,"userorderid":orderId], encoding: URLEncoding.default)
        case .getinfo:
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!], encoding: URLEncoding.default)
        case .getalladdress:
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!], encoding: URLEncoding.default)
        case .setaddress(let id):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "docaddressid":id], encoding: URLEncoding.default)
        case .addcalendar(let date, let time, let event, let addressid):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "doccalendarday":date,"doccalendaradressid":addressid, "doccalendaraffair":event, "doccalendartime":time], encoding: URLEncoding.default)
        case .listhistoryorder(let page):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "page":page], encoding: URLEncoding.default)
        case .getbalance:
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!], encoding: URLEncoding.default)
        case .listreceivenotification(let page):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "page":page], encoding: URLEncoding.default)
        case .getorderdetail(let orderId):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "userorderid":orderId], encoding: URLEncoding.default)
        case .getalipayaccount:
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!], encoding: URLEncoding.default)
        case .updatealipayaccount(let account):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "alipayaccount":account], encoding: URLEncoding.default)
        case .updateallnotificationtoread:
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!], encoding: URLEncoding.default)
        case .updatenotificationtoread(let msgId):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "notificationid":msgId], encoding: URLEncoding.default)
        case .updateintroduce(let str):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "docabs":str], encoding: URLEncoding.default)
        case .updateexpert(let str):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "docexpert":str], encoding: URLEncoding.default)
        case .deletecalendar(let id):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "doccalendarid":id], encoding: URLEncoding.default)
        case .getcalendar(let page):
           return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "page":page], encoding: URLEncoding.default)
        case .listtraderecord(let page):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "page":page], encoding: URLEncoding.default)
        case .deleteallreceivenotification:
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!], encoding: URLEncoding.default)
        case .addaddress(let location, let province, let city,let docaddressarea, let docaddressother, let lon, let lat):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "docaddresslocation":location, "docaddressprovince":province, "docaddresscity":city, "docaddresslon":lon, "docaddresslat":lat,"docaddressarea":docaddressarea, "docaddressother":docaddressother], encoding: URLEncoding.default)
        case .deleteaddress(let placeId):
            return .requestParameters(parameters: ["docloginid":user_default.userId.getStringValue()!, "docaddressid":placeId], encoding: URLEncoding.default)
        }
    }
    
    public var validate: Bool {
        return false
    }
    public var headers: [String : String]? {
        return nil
    }
    
}
