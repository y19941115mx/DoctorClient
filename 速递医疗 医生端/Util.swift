//
//  Util.swift


import UIKit
import Kingfisher
import Toast_Swift
import Alamofire
import Moya
import SVProgressHUD
import ObjectMapper
import SwiftyJSON
import SwiftHash
import SnapKit
import RealmSwift
import LEEAlert


let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let APPLICATION = UIApplication.shared.delegate as! AppDelegate
let APPVERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String

let ERRORMSG = "获取服务器数据失败"
let CATCHMSG = "解析服务器数据失败"


// 全局变量
struct StaticClass {
    //     static let RootIP = "http://1842719ny8.iok.la:14086"
    static let RootIP = "http://www.dsdoc120.com:6221"
    //    static let RootIP = "http://120.77.32.15:8080"
    static let BaseApi = RootIP + "/internetmedical/doctor"
    static let BaseCommonAPI = RootIP + "/internetmedical/common"
    static let GetDept = RootIP + "/internetmedical/doctor/getdept"
    static let GaodeAPIKfey = "dc63bec745429fca2107bdd7e57f7e3c"
    static let TuisongAPIKey = "uf3RsBMfrhLyZhD4G5GPrTxQa2huBIIS"
    static let HuanxinAppkey = "1133171107115421#medicalclient"
    static let BuglyAPPID = "4ec5df48d6"
    static let ShareSDKAPPKey = "2336f7199e004"
    static let UmengAPPID = "5a630b9e8f4a9d2b7e0000e0"
    static let ShareURL = "118.89.172.204:6221/SystemManage/Doctor/schedule.action"
}
//日志打印
public func dPrint<N>(message:N,fileName:String = #file,methodName:String = #function,lineNumber:Int = #line){
    #if DEBUG
        print("------ BEGIN \n\(fileName as NSString)\n方法:\(methodName)\n行号:\(lineNumber)\n打印信息:\(message)\n------ end");
    #endif
}

// Toast 打印
public func showToast(_ view:UIView, _ message:String) {
    var style = ToastStyle()
    style.backgroundColor = UIColor.APPColor
    view.makeToast(message, duration: 2.0, position: .bottom, style:style)
}

public func ToastError(_ message:String) {
    //时间
    SVProgressHUD.setMinimumDismissTimeInterval(1)
    SVProgressHUD.showError(withStatus: message)
}

public func Toast(_ message:String) {
    SVProgressHUD.setMinimumDismissTimeInterval(1)
    SVProgressHUD.showSuccess(withStatus: message)
}

// 网络请求
// 网络请求
class NetWorkUtil<T:BaseAPIBean> {
    var method:API?
    
    init(method:API) {
        self.method = method
    }
    
    class func getRequest(urlString: String, params : [String : Any], success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        Alamofire.request(urlString, method: .get, parameters: params).validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    success(value as! [String : AnyObject])
                case .failure(let error):
                    failture(error)
                }
        }
    }
    
    class func setRequestTimeout() -> MoyaProvider<API> {
        let requestClosure = { (endpoint: Endpoint<API>, done: @escaping MoyaProvider<API>.RequestResultClosure) in
            do {
                var request = try endpoint.urlRequest()
                request.timeoutInterval = 5   //设置请求超时时间
                done(.success(request))
            }catch {
                ToastError(ERRORMSG)
            }
        }
        return  MoyaProvider<API>(requestClosure: requestClosure)
    }
    
    func newRequest(successhandler:((_ bean:T, _ JSONObj:JSON) -> Void)?,failhandler:((_ bean:T, _ JSONObj:JSON) -> Void)? = nil ) {
        let Provider = NetWorkUtil.setRequestTimeout()
        SVProgressHUD.show()
        Provider.request(method!) { result in
            switch result {
            case let .success(response):
                do {
                    SVProgressHUD.dismiss()
                    let jsonObj =  try response.mapJSON()
                    let bean = Mapper<T>().map(JSONObject: jsonObj)
                    let json = JSON(jsonObj)
                    if let bean = bean {
                        if bean.code == 100 {
                            if successhandler != nil {
                                successhandler!(bean, json)
                            }
                        }else {
                            if failhandler != nil {
                                failhandler!(bean, json)
                            }else {
                                ToastError(bean.msg!)
                            }
                        }
                    }
                }catch {
                    dPrint(message: "response:\(response)")
                    ToastError(CATCHMSG)
                }
            case let .failure(error):
                SVProgressHUD.dismiss()
                dPrint(message: "error:\(error)")
                ToastError(ERRORMSG)
            }
        }
    }
    
    func newRequestWithOutHUD(successhandler:((_ bean:T, _ JSONObj:JSON) -> Void)? ,failhandler:((_ bean:T, _ JSONObj:JSON) -> Void)? = nil) {
        let Provider = NetWorkUtil.setRequestTimeout()
        Provider.request(method!) { result in
            switch result {
            case let .success(response):
                do {
                    let jsonObj =  try response.mapJSON()
                    let bean = Mapper<T>().map(JSONObject: jsonObj)
                    let json = JSON(jsonObj)
                    if let bean = bean {
                        if bean.code == 100 {
                            if successhandler != nil {
                                successhandler!(bean, json)
                            }
                        }else {
                            if failhandler != nil {
                                failhandler!(bean, json)
                            }else {
//                                ToastError(bean.msg!)
                            }
                        }
                    }
                }catch {
                    dPrint(message: "response:\(response)")
//                    ToastError(CATCHMSG)
                }
            case let .failure(error):
                dPrint(message: "error:\(error)")
//                ToastError(ERRORMSG)
            }
        }
    }
    
    //获取科室数据
    class func getDepartMent(success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()){
        getRequest(urlString: StaticClass.GetDept, params: [:], success: success, failture:failture)
    }
}

//MARK: - 地图定位
class MapUtil {
    class func singleLocation(successHandler:((_ location:CLLocation, _ reGeocode:AMapLocationReGeocode?) -> Void)?, failHandler:@escaping () -> Void ) {
        APPLICATION.locationManager.requestLocation(withReGeocode: true, completionBlock: {(location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            
            if let error = error {
                let error = error as NSError
                failHandler()
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
//                    let msg = "定位错误:{\(error.code) - \(error.localizedDescription)};"
//                    Toast(msg)
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
//                    let msg = "获取地理位置失败，请检查GPS设置;"
//                    Toast(msg)
                }
            }else {
                if let location = location  {
                    APPLICATION.lon = location.coordinate.longitude.description
                    APPLICATION.lat = location.coordinate.latitude.description
                    if successHandler != nil {
                        successHandler!(location, reGeocode)
                    }
                }
            }
            
        })
    }
}


// UserDefault UserDefault相关的枚举值
enum user_default:String {
    case userId, password, typename, pix, token, username, title, account, channel_id, phoneNum
    func getStringValue()->String? {
        return UserDefaults.standard.string(forKey: self.rawValue)
    }
    
    //UserDefaults 进行本地存储
    static func setUserDefault(key:user_default, value:Any){
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    //UserDefaults 清空数据
    static func clearUserDefault(){
        UIApplication.shared.applicationIconBadgeNumber = 0
        UserDefaults.standard.removeObject(forKey: "typename")
        UserDefaults.standard.removeObject(forKey: "pix")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "title")
        UserDefaults.standard.removeObject(forKey: "account")
        UserDefaults.standard.removeObject(forKey: "password")
    }
    // 退出登录
    static func logout(_ msg:String) {
        let vc_login = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
        APPLICATION.window?.rootViewController = vc_login
        NetWorkUtil<BaseAPIBean>.init(method: .exit).newRequestWithOutHUD(successhandler: { (bean, json) in
            user_default.clearUserDefault()
            EMClient.shared().logout(false, completion: { (error)
                in
                if error == nil {
                    Toast("\(msg) 账号退出成功")
                }else {
                    Toast("\(msg) 账号退出失败")
                }
            })
        })
        
    }
}


// Alert 相关
class AlertUtil: NSObject {
    
    class func popOptional(optional:[String], handler:@escaping (_ value: String)->()) {
        let view = SelectedListView.init(frame: CGRect.init(x: 0, y: 0, width: 280, height: 0), style: .plain)
        view.isSingle = true
        
        var arr = [SelectedListModel]()
        for (index, item) in optional.enumerated() {
            arr.append(SelectedListModel.init(sid: index, title: item))
        }
        view.array = arr
        view.selectedBlock = { array in
            LEEAlert.close(completionBlock: {
                handler(array![0].title)
            })
        }
        LEEAlert.alert().config.leeTitle("请选择")!.leeItemInsets(UIEdgeInsets.init(top: 20, left: 0, bottom: 20, right: 0))!.leeCustomView(view)!.leeItemInsets(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))!.leeHeaderInsets(UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0))!.leeClickBackgroundClose(true)!.leeShow()
    }
    
    /**
     选择弹出框
     - parameter title: 标题
     - parameter msg:   消息
     - parameter btns:  弹框
     */
    class func popMenu(vc:UIViewController, title:String,msg:String,btns:[String], handler:@escaping (_ value: String)->()) {
        
        let alertController = UIAlertController(title: title, message: msg,
                                                preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        for btn in btns {
            let action = UIAlertAction(title: btn, style: .default) { (UIAlertAction) -> Void in
                handler(UIAlertAction.title!)
            }
            alertController.addAction(action)
        }
        // 添加Pad支持
        alertController.popoverPresentationController?.sourceView = vc.view
        alertController.popoverPresentationController?.sourceRect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        
        vc.present(alertController, animated: true, completion: nil)
    }
    
    class func popAlert(vc:UIViewController, msg:String,hasCancel:Bool = true,okhandler: @escaping ()->())
    {
        // 弹出提示框
        let alertController = UIAlertController(title: "提示",
                                                message: msg, preferredStyle: .alert)
        if hasCancel {
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }
        let okAction = UIAlertAction(title: "确认", style: .default, handler: {
            action in
            okhandler()
        })
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    
    class func popAlertWithDelAction(vc:UIViewController, msg:String, oktitle:String,deltitle:String,okhandler: @escaping ()->(), delhandler: @escaping ()->())
    {
        // 弹出提示框
        let alertController = UIAlertController(title: "提示",
                                                message: msg, preferredStyle: .alert)
        let delAction = UIAlertAction(title: deltitle, style: .destructive, handler: { action in
            delhandler()
        })
        let okAction = UIAlertAction(title: oktitle, style: .default, handler: {
            action in
            okhandler()
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        alertController.addAction(delAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    // 弹出带文本输入框
    class func popTextFields(vc:UIViewController,title:String, textfields:[UITextField], okhandler: @escaping (_ textfields:[UITextField])->()) {
        let alertController = UIAlertController(title: title,
                                                message: "", preferredStyle: .alert)
        for item in textfields {
            alertController.addTextField {
                (textField: UITextField!) -> Void in
                textField.placeholder = item.placeholder
                textField.keyboardType = item.keyboardType
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
            okhandler(alertController.textFields!)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    //TODO: - 弹出自定义弹出框
    class func popCustomAlerm(vc:UIViewController,title:String,Views:[UIView], addViewConstrans: @escaping () -> Void, okhandler: @escaping ([UIView]) -> Void) {
        
    }
    
}

class ImageUtil{
    
    class func URLToImg(url:URL) -> UIImage {
        var img = UIImage.init()
        do {
            let data = try Data.init(contentsOf: url)
            img = UIImage.init(data: data)!
        }catch {
            img = #imageLiteral(resourceName: "photo_default")
        }
        return img
    }
    
    // 设置按钮不可用灰色
    class func setButtonDisabledImg(button:UIButton){
        button.setBackgroundImage(ImageUtil.color2img(color: UIColor.APPGrey), for: .disabled)
    }
    
    class func color2img(color:UIColor) -> UIImage{
        //  颜色转换为背景图片
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor);
        context.fill(rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
        
    }
    
    static public func setAvator(path:String, imageView:UIImageView) {
        let url = URL(string: path)
        imageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "photo_loading"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    // 图片转为Data类型
    class public func image2Data(image:UIImage) -> Data{
        return UIImageJPEGRepresentation(image, 0.1)!
    }
}

class StringUTil {
    
    // 消除空格
    class public func trimmingCharactersWithWhiteSpaces(_ str:String) -> String{
        return str.trimmingCharacters(in: .whitespaces)
    }
    
    class public func isEarlyThanNow(_ date:Date)->Bool {
        let now = NSDate()
        return now.isLaterThanDate(date)
        
    }
    
    // 转换MD5值
    class public func transformMD5(_ string:String)->String {
        return MD5(string)
    }
    // 字符串转 Date
    class public func StringToDate(_ dateStr:String,_ dformatter:DateFormatter) -> Date? {
        return dformatter.date(from: dateStr)
    }
    
    class public func isDateEqual(_ date1:Date, _ date2:Date)->Bool {
        let date = date1 as! NSDate
        return date.isEqual(to: date2)
    }
    
    class public func isDateLater(_ date1:Date, _ date2:Date)->Bool {
        let date = date1 as! NSDate
        return date.isLaterThanDate(date2)
    }
    
    // Date转字符串
    class public func DateToString(_ date:Date,_ dformatter:DateFormatter) -> String {
        return dformatter.string(from: date)
    }
    
    // 根据date 获取年月日
    class public func DateToComponents(_ data:Date) -> DateComponents {
        let calendar = Calendar.current
        return  calendar.dateComponents([.year,.month, .day, .hour,.minute,.second], from: data )
    }
    
    // 将时间戳转换为时间字符串
    class public func timestamp2string(timeStamp:Int) -> String{
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp/1000)
        let date = Date(timeIntervalSince1970: timeInterval)
        
        //格式化输出
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dformatter.string(from: date)
    }
    
    // 获取当前系统时间字符串
    class public func getCurTimeStr() -> String{
        let date = NSDate()
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let strNowTime = timeFormatter.string(from:date as Date) as String
        return strNowTime
    }
    
    // 美国时间转换为中国 yyyy-MM-dd HH:mm:ss
    class public func usTime2chinaTime(_ str:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale! // zh_CN  en_US
        var enddata = str
        enddata.insert(contentsOf: " at ", at: enddata.index(enddata.startIndex, offsetBy: 12))
        
        let ndate = dateFormatter.date(from: enddata)
        let endDateString = ndate?.description
        let ns2=(endDateString! as NSString).substring(to: 19)
        return ns2
    }
    
    // 获取显示时间（几分钟前，几小时前，几天前）
    class public func getComparedTimeStr(str:String) -> String{
        //把字符串转为NSdate
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeDate = timeFormatter.date(from: str)
        let currentDate = NSDate()
        
        // 获得时间差
        let timeInterval = currentDate.timeIntervalSince(timeDate!)
        var temp = 0
        var result:String?
        
        //处理时间差
        if timeInterval / 60 < 1{
            result = "刚刚"
        }
        else if timeInterval/60 < 60 {
            temp = Int(timeInterval/60)
            result = "\(temp)分钟前"
        }
        else if timeInterval / 60 / 60 < 24 {
            temp = Int(timeInterval / 60 / 60)
            result = "\(temp)小时前"
        }
        else if timeInterval / 60 / 60 / 24 < 30{
            temp = Int(timeInterval / 60 / 60 / 24)
            result = "\(temp)天前"
        }
        else if timeInterval / 60 / 60 / 24 / 30 < 12 {
            temp = Int(timeInterval / 60 / 60 / 24 / 30)
            result = "\(temp)个月前"
        } else{
            temp = Int(timeInterval / 60 / 60 / 24 / 30 / 12)
            result = "\(temp)年前"
        }
        return  result!;
    }
    
    class func splitImage(str:String) -> [String] {
        return str.components(separatedBy: ",")
    }
}

extension Array {
    static func ArraytoString(array:Array<String>,separator:String) -> String{
        return array.joined(separator: separator)
    }
}

public class DBHelper:NSObject {
    // 初始化数据库
    class public func setUpDB() {
        /* Realm 数据库配置，用于数据库的迭代更新 */
        let schemaVersion: UInt64 = 0
        let config = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: { migration, oldSchemaVersion in
            
            /* 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构 */
            if (oldSchemaVersion < schemaVersion) {}
        })
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen { (realm, error) in
            
            /* Realm 成功打开，迁移已在后台线程中完成 */
            if let _ = realm {
                
                print("Realm 数据库配置成功")
            }
                /* 处理打开 Realm 时所发生的错误 */
            else if let error = error {
                
                print("Realm 数据库配置失败：\(error.localizedDescription)")
            }
        }
    }
}

public class NavigationUtil<T:UIViewController>:NSObject{
    class public func setTabBarSonController(index:Int, handler:((T)->Void)?,nvcIndex:Int = 0){
        var vc = APPLICATION.tabBarController?.viewControllers![index]
        if vc is UINavigationController {
            let nvc = vc as! UINavigationController
            vc = nvc.viewControllers[nvcIndex]
        }
        if let vc = vc as? T{
            if let handler = handler {
                handler(vc)
            }
            APPLICATION.tabBarController?.selectedIndex = index
        }
    }
    class public func setRootViewController(vc:UIViewController) {
        APPLICATION.window?.rootViewController = vc
    }
}






