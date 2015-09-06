//
//  NetworkUserModelDataSource.swift
//  travelMapMvvm
//
//  Created by green on 15/9/1.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa

class NetworkUserModelDataSource: UserModelDataSourceProtocol {
    
    // MARK: - 单例
    
    class func shareInstance()->UserModelDataSourceProtocol{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:NetworkUserModelDataSource? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance=NetworkUserModelDataSource()
        })
        return YRSingleton.instance!
    }
    
    func telephoneLogin(telephone: Int, password: String) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in

            let paramters: [String:AnyObject] = [
                
                "telephone" : telephone,
                "password"  : password
            ]
            
            NetRequestClass.netRequestGETWithRequestURL({ (error, data) -> Void in
                
                if error == nil {
                    
                    var user = UserModel()
                    
                    user <-- data!
                    
                    subscriber.sendNext(user)
                    subscriber.sendCompleted()
                } else {
                    
                    subscriber.sendError(error)
                    
                }
            }, requestURlString: "URL", parameters: paramters)
            
            return nil
        })
    }
    
    func sinaLogin(sinaOpenId: String) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            let paramters: [String:AnyObject] = [
                
                "sinaOpenId" : sinaOpenId
            ]
            
            NetRequestClass.netRequestGETWithRequestURL({ (error, data) -> Void in
                
                if error == nil {
                    
                    var user = UserModel()
                    
                    user <-- data!
                    
                    subscriber.sendNext(user)
                    subscriber.sendCompleted()
                } else {
                    
                    subscriber.sendError(error)
                    
                }
            }, requestURlString: "URL", parameters: paramters)
            
            return nil
        })
    }
    
    func qqLogin(appKey:String, accessToken:String, qqOpenId: String) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            let paramters: [String:AnyObject] = [
                
                "qqOpenId" : qqOpenId
            ]
            
            NetRequestClass.netRequestGETWithRequestURL({ (error, data) -> Void in
                
                if error == nil {
                    
                    var user = UserModel()
                    
                    user <-- data!
                    
                    subscriber.sendNext(user)
                    subscriber.sendCompleted()
                } else {
                    
                    subscriber.sendError(error)
                    
                }
            }, requestURlString: "URL", parameters: paramters)
            
            return nil
        })
    }
    
    func saveUser(user: UserModel) {
        
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(user),forKey:kLoginUserKey)
        
        // 设置登录页面默认显示的手机号码
        if let tel = user.telephone {
            
            NSUserDefaults.standardUserDefaults().setObject("\(tel)", forKey: kLoginPageDefaultTelephone)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func clearUser() {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(kLoginUserKey)
    }
    
    func queryUser() -> UserModel? {
        
        var loginUser: UserModel?
        var loginUserData = NSUserDefaults.standardUserDefaults().objectForKey(kLoginUserKey) as? NSData
        if let loginUserData=loginUserData {
            loginUser = NSKeyedUnarchiver.unarchiveObjectWithData(loginUserData) as? UserModel
        }
        return loginUser
    }
    
    func queryLoginPageDefaultTelephone() -> String {
        
        if let defaultTel = NSUserDefaults.standardUserDefaults().objectForKey(kLoginPageDefaultTelephone) as? String {
            
            return defaultTel
        } else {
            
            return ""
        }
        
    }
}