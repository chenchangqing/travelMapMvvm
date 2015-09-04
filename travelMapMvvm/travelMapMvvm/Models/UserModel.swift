//
//  UserModel.swift
//  travelMap
//
//  Created by green on 15/6/23.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import ReactiveCocoa

// 用户信息
class UserModel: NSObject, NSCoding, Deserializable {
    
    var userId      :String?        // ID
    var userName    :String?        // 用户名
    var userPicUrl  :String?        // 头像地址
    var telephone   :Int?           // 手机号
    var email       :String?        // 邮箱
    
    override init() { }
    
    required init(data : [String:AnyObject]) {
        
        userId          <-- data["userId"]
        userName        <-- data["userName"]
        userPicUrl      <-- data["userPicUrl"]
        telephone       <-- data["telephone"]
        email           <-- data["email"]
    }
    
    required init(coder decoder: NSCoder) {
        
        self.userId     = decoder.decodeObjectForKey("userId") as? String
        self.userName   = decoder.decodeObjectForKey("userName") as? String
        self.userPicUrl = decoder.decodeObjectForKey("userPicUrl") as? String
        self.telephone  = decoder.decodeObjectForKey("telephone") as? Int
        self.email      = decoder.decodeObjectForKey("email") as? String
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        
        encoder.encodeObject(self.userId,forKey: "userId")
        encoder.encodeObject(self.userName,forKey: "userName")
        encoder.encodeObject(self.userPicUrl,forKey: "userPicUrl")
        encoder.encodeObject(self.telephone,forKey: "telephone")
        encoder.encodeObject(self.email, forKey: "email")
    }
    
}