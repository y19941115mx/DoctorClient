//
//  ModelBean.swift
//
//

import UIKit
import RealmSwift


class UserInfo: Object {
    @objc dynamic var nick_name = ""
    @objc dynamic var user_photo = ""
    @objc dynamic var user_id = ""
    
    // 设置主键
    override static func primaryKey() -> String? {
        return "user_id"
        
    }
    // 设置搜索字段
    override static func indexedProperties() -> [String] {
        return ["user_id"]
    }
    
    /// 更新用户信息
    class func updateUserInfo(user_id: String,nick_name: String,user_photo: String){
        let realm = try! Realm()
        var value =  ["user_id": user_id]
        if user_photo.count > 0 {
            value["user_photo"] = user_photo
        }
        if nick_name.count > 0 {
            value["nick_name"] = nick_name
        }
        try! realm.write {
            realm.create(UserInfo.self,value: value, update: true)
        }
    }
    
    /// 通过UserID搜索用户
    class func searchUser(user_id: String) -> UserInfo? {
        let realm = try! Realm()
        let result = realm.objects(UserInfo.self).filter("user_id == \"\(user_id)\"")
        if result.count > 0 {
            return result[0]
        }
        return nil
    }
}
