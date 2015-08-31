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
    var telephone   :String?        // 手机号
    var email       :String?        // 邮箱
    
    private var imageDataSourceProtocol = ImageDataSource.shareInstance()
    
    var requestUserPic  : NSURLRequest? {
        get {
            let url = isValidStrategyPicUrl()
            return url == nil ? nil : NSURLRequest(URL: url!)
        }
    }
    
    /**
     * 用户头像图片是否有效
     */
    private func isValidStrategyPicUrl() -> NSURL? {
        
        if let picUrl=userPicUrl {
            
            if let url=NSURL(string: picUrl) {
                
                return url
            }
        }
        return nil
    }
    
    /**
     * 下载用户头像图片
     */
    func downloadUserPicImageWithUrl() -> RACSignal? {
        
        if let url = isValidStrategyPicUrl() {
            
            return imageDataSourceProtocol.downloadImageWithUrl(url)
        }
        
        return nil
    }
    
    override init() { }
    
    required init(data : [String:AnyObject]) {
        
        userId          <-- data["userId"]
        userName        <-- data["userName"]
        userPicUrl      <-- data["userPicUrl"]
        telephone       <-- data["telephone"]
        email           <-- data["email"]
    }
    
    required init(coder decoder: NSCoder) {
        
        self.userId     = decoder.decodeObjectForKey("userId") as! String?
        self.userName   = decoder.decodeObjectForKey("userName") as! String?
        self.userPicUrl = decoder.decodeObjectForKey("userPicUrl") as! String?
        self.telephone  = decoder.decodeObjectForKey("telephone") as! String?
        self.email      = decoder.decodeObjectForKey("email") as! String?
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        
        encoder.encodeObject(self.userId,forKey: "userId")
        encoder.encodeObject(self.userName,forKey: "userName")
        encoder.encodeObject(self.userPicUrl,forKey: "userPicUrl")
        encoder.encodeObject(self.telephone,forKey: "telephone")
        encoder.encodeObject(self.email, forKey: "email")
    }
    
}