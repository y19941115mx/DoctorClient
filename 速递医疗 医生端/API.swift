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
           return  .requestParameters(parameters: ["docloginphone":phone, "docloginpwd": pwd], encoding: URLEncoding.default)
        case .docregister(let phone, let pwd, let code):
            return .requestParameters(parameters: ["docloginphone":phone, "docloginpwd":pwd, "code":code], encoding: URLEncoding.default)
        case .getmsgcode(let phone):
            return .requestParameters(parameters: ["docloginphone":phone], encoding: URLEncoding.default)
        case .phonetest(let phone):
            return .requestParameters(parameters: ["docloginphone":phone], encoding: URLEncoding.default)
        }
    }
    
    public var validate: Bool {
        return false
    }
    public var headers: [String : String]? {
        return nil
    }
    
}
