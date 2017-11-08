//
//  Util.swift


import UIKit
import Kingfisher
import Toast_Swift
import Alamofire
import Moya
import SVProgressHUD
import ObjectMapper

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let APPLICATION = UIApplication.shared.delegate as! AppDelegate
let ERRORMSG = "获取服务器数据失败"
let CATCHMSG = "解析服务器数据失败"
let LOGINID = Int(user_default.userId.getStringValue()!)

// 全局变量
struct StaticClass {
    static let BaseApi = "http://1842719ny8.iok.la:14086/internetmedical/doctor"
    static let RootIP = "http://1842719ny8.iok.la:14086"
    static let PictureIP = RootIP + "/picture/"
    static let GetDept = RootIP + "/internetmedical/doctor/getdept"
}
//日志打印
public func dPrint<N>(message:N,fileName:String = #file,methodName:String = #function,lineNumber:Int = #line){
    #if DEBUG
        print("------ BEGIN \n\(fileName as NSString)\n方法:\(methodName)\n行号:\(lineNumber)\n打印信息:\(message)\n------ end");
    #endif
}

public func showToast(_ view:UIView, _ message:String) {
    var style = ToastStyle()
    style.backgroundColor = UIColor.APPColor
    view.makeToast(message, duration: 2.0, position: .bottom, style:style)
}

// 网络请求
class NetWorkUtil<T:BaseAPIBean> {
    var method:API?
    var vc:UIViewController = UIViewController()
    
    init(method:API, vc:UIViewController) {
        self.method = method
        self.vc = vc
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
    
    func newRequest(handler:@escaping (_ bean:T) -> Void) {
        let Provider = MoyaProvider<API>()
        SVProgressHUD.show()
        Provider.request(method!) { result in
            switch result {
            case let .success(response):
                do {
                    SVProgressHUD.dismiss()
                    let bean = Mapper<T>().map(JSONObject: try response.mapJSON())
                    handler(bean!)
                }catch {
                    showToast(self.vc.view, CATCHMSG)
                }
            case let .failure(error):
                SVProgressHUD.dismiss()
                dPrint(message: "error:\(error)")
                showToast(self.vc.view, ERRORMSG)
            }
        }
    }
    
    //获取科室数据
    class func getDepartMent(success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()){
        getRequest(urlString: StaticClass.GetDept, params: [:], success: success, failture:failture)
    }
}


// UserDefault UserDefault相关的枚举值
enum user_default:String {
    case userId, type, pix, token, username
    func getStringValue()->String? {
        switch self {
        case .type:
            return nil
        default:
            return UserDefaults.standard.string(forKey: self.rawValue)
        }
    }
    func getBoolValue()->Bool {
        return UserDefaults.standard.bool(forKey: self.rawValue)
    }
    //UserDefaults 进行本地存储
    static func setUserDefault(key:user_default, value:Any){
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    //UserDefaults 清空数据
    static func clearUserDefaultValue(key:String){
        UserDefaults.standard.removeObject(forKey: key)
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
    // 弹出输入框
    class func popTextFields(vc:UIViewController, okhandler: @escaping (_ textfields:[UITextField])->()) {
        let alertController = UIAlertController(title: "输入内容",
                                                message: "", preferredStyle: .alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "姓名"
        }
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "性别(男/女)"
        }
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "年龄"
            textField.keyboardType = .numberPad
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
}

class ImageUtil{
    //设置图片
    class public func setImage(path:String, imageView:UIImageView){
        let url = URL(string:path)
        imageView.kf.setImage(with: url)
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
        //        imageView.kf.setImage(with: url)
        imageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "default"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    // 图片转为Data类型
    class public func image2Data(image:UIImage) -> Data{
        return UIImageJPEGRepresentation(image, 0.1)!
    }
}

class StringUTil {
    
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




