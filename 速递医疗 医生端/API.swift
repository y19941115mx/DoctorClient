//
//  WeChatAPI.swift


import Foundation
import Moya

// 创建请求
public enum API {
    case doclogin(String, String) // 登录
    case docregister(String, String, String) // 注册
    case getmsgcode(String)  // 发送验证码
    case phonetest(String) //验证短信验证码
    case updatepix(Data) // 上传头像
    case listsicks(Int, String, String) // 获取首页推荐病情数据
    case listsicksBytype(Int, Int, String, String) //  首页分类显示
    case getsickdetail(Int) // 获取病情详细信息
    case editpassword(String, String, String) // 重置密码
    case exit // 退出登录

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
        case .getmsgcode(let phone):
            return .requestParameters(parameters: ["docloginphone":phone], encoding: URLEncoding.default)
        case .phonetest(let phone):
            return .requestParameters(parameters: ["docloginphone":phone], encoding: URLEncoding.default)
        case .listsicks(let page, let lat, let lon):
            return .requestParameters(parameters: ["docloginid":LOGINID!, "page":page, "lat":lat, "lon":lon], encoding: URLEncoding.default)

        case .updatepix(let data):
        return .uploadCompositeMultipart([MultipartFormData.init(provider: .data(data), name: "pictureFile", fileName: "photo.jpg", mimeType:"image/png")], urlParameters: ["docloginid": LOGINID!])

        case .listsicksBytype(let page, let type, let lat, let lon):
            return .requestParameters(parameters: ["docloginid":LOGINID!, "page":page, "lat":lat, "lon":lon, "type":type], encoding: URLEncoding.default)
        case .getsickdetail(let sickId):
            return .requestParameters(parameters: ["docloginid":LOGINID!, "usersickid": sickId], encoding: URLEncoding.default)
        case .editpassword(let phone, let pass, let code):
            return .requestParameters(parameters: ["docloginphone":phone, "docloginpwd":pass, "code":code], encoding: URLEncoding.default)
        case .exit:
            return .requestParameters(parameters: ["docloginid":LOGINID!], encoding: URLEncoding.default)
        }
    }
    
    public var validate: Bool {
        return false
    }
    public var headers: [String : String]? {
        return nil
    }
    
}
