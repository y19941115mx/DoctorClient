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


let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let APPLICATION = UIApplication.shared.delegate as! AppDelegate
let ERRORMSG = "获取服务器数据失败"
let CATCHMSG = "解析服务器数据失败"


// 全局变量
struct StaticClass {
     static let RootIP = "http://1842719ny8.iok.la:14086"
//    static let RootIP = "http://192.168.2.2:8080"
    static let BaseApi = RootIP + "/internetmedical/doctor"
    static let GetDept = RootIP + "/internetmedical/doctor/getdept"
    static let GaodeAPIKey = "dc63bec745429fca2107bdd7e57f7e3c"
    static let TuisongAPIKey = "uf3RsBMfrhLyZhD4G5GPrTxQa2huBIIS"
    static let HuanxinAppkey = "1133171107115421#medicalclient"
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

public func Toast(_ message:String) {
    var style = ToastStyle()
    style.backgroundColor = UIColor.APPColor
    let view = APPLICATION.window?.rootViewController?.view
    view?.makeToast(message, duration: 2.0, position: .bottom, style:style)
}

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
    
    func newRequest(handler:@escaping (_ bean:T, _ JSONObj:JSON) -> Void) {
        let Provider = MoyaProvider<API>()
        SVProgressHUD.show()
        Provider.request(method!) { result in
            switch result {
            case let .success(response):
                do {
                    SVProgressHUD.dismiss()
                    let jsonObj =  try response.mapJSON()
                    let bean = Mapper<T>().map(JSONObject: jsonObj)
                    let json = JSON(jsonObj)
                    handler(bean!, json)
                }catch {
                    dPrint(message: "response:\(response)")
                    Toast(CATCHMSG)
                }
            case let .failure(error):
                SVProgressHUD.dismiss()
                dPrint(message: "error:\(error)")
                Toast(ERRORMSG)
            }
        }
    }
    
    func newRequestWithoutHUD(handler:@escaping (_ bean:T, _ JSONObj:JSON) -> Void) {
        let Provider = MoyaProvider<API>()
        Provider.request(method!) { result in
            switch result {
            case let .success(response):
                do {
                    let jsonObj =  try response.mapJSON()
                    let bean = Mapper<T>().map(JSONObject: jsonObj)
                    let json = JSON(jsonObj)
                    handler(bean!, json)
                }catch {
                    dPrint(message: "response:\(response)")
                    Toast(CATCHMSG)
                }
            case let .failure(error):
                dPrint(message: "error:\(error)")
                Toast(ERRORMSG)
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
    
    class func singleLocation(successHandler:((_ location:CLLocation, _ reGeocode:AMapLocationReGeocode?) -> Void)?, failhandler:@escaping () -> Void  ) {
        APPLICATION.locationManager.requestLocation(withReGeocode: true, completionBlock: {(location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            
            if let error = error {
                let error = error as NSError
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    let msg = "定位错误:{\(error.code) - \(error.localizedDescription)};"
                    showToast((APPLICATION.window?.rootViewController?.view)!, msg)
                    failhandler()
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    let msg = "逆地理错误:{\(error.code) - \(error.localizedDescription)};"
                    failhandler()
                    Toast(msg)
                }
            }
            if let location = location  {
                APPLICATION.lon = String(location.coordinate.longitude)
                APPLICATION.lat = String(location.coordinate.latitude)
                if successHandler != nil {
                    successHandler!(location, reGeocode)
                }
            }
            
        })
    }
}


// UserDefault UserDefault相关的枚举值
enum user_default:String {
    case userId, password, typename, pix, token, username, title, account, channel_id
    func getStringValue()->String? {
        return UserDefaults.standard.string(forKey: self.rawValue)
    }
    
    //UserDefaults 进行本地存储
    static func setUserDefault(key:user_default, value:Any){
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    //UserDefaults 清空数据
    static func clearUserDefault(){
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "typename")
        UserDefaults.standard.removeObject(forKey: "pix")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "title")
        UserDefaults.standard.removeObject(forKey: "account")
        UserDefaults.standard.removeObject(forKey: "password")
    }
}


// Alert 相关
class AlertUtil: NSObject {
    
    /**
     选择弹出框
     - parameter title: 标题
     - parameter msg:   消息
     - parameter btns:  弹框项
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
    
    class func popAlert(vc:UIViewController, msg:String, okhandler: @escaping ()->())
    {
        // 弹出提示框
        let alertController = UIAlertController(title: "提示",
                                                message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确认", style: .default, handler: {
            action in
            okhandler()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    class func popAlertWithDelAction(vc:UIViewController, msg:String, okhandler: @escaping ()->(), delhandler: @escaping ()->())
    {
        // 弹出提示框
        let alertController = UIAlertController(title: "提示",
                                                message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { action in
            delhandler()
        })
        let okAction = UIAlertAction(title: "确认", style: .default, handler: {
            action in
            okhandler()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
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
        //        imageView.kf.setImage(with: url)
        imageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "photo_loading"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    // 图片转为Data类型
    class public func image2Data(image:UIImage) -> Data{
        return UIImageJPEGRepresentation(image, 0.1)!
    }
}

class StringUTil {
    
    // 转换MD5值
    class public func transformMD5(_ string:String)->String {
        return MD5(string)
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






