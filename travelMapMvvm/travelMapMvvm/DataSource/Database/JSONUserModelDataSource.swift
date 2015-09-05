//
//  JSONUserModelDataSource.swift
//  travelMapMvvm
//
//  Created by green on 15/9/1.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa

class JSONUserModelDataSource: UserModelDataSourceProtocol {
    
    // MARK: - 单例
    
    class func shareInstance()->UserModelDataSourceProtocol{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:JSONUserModelDataSource? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance=JSONUserModelDataSource()
        })
        return YRSingleton.instance!
    }
    
    func telephoneLogin(telephone: Int, password: String) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 1)), dispatch_get_main_queue(), { () -> Void in
                
                let resultDic = ReadJsonClass.readJsonData("telephoneLogin")
                
                if resultDic.error == nil {
                    
                    if let data: AnyObject=resultDic.data {
                        
                        var user = UserModel()
                        
                        user <-- data[kData]
                        
                        subscriber.sendNext(user)
                        subscriber.sendCompleted()
                    } else {
                        
                        subscriber.sendError(NSError(
                            domain:kErrorDomain,
                            code: ErrorEnum.JSONError.errorCode,
                            userInfo: [NSLocalizedDescriptionKey:ErrorEnum.JSONError.rawValue]
                            ))
                    }
                } else {
                    
                    subscriber.sendError(resultDic.error!)
                }
            })
            return nil
        })
    }
    
    func sinaLogin(sinaOpenId: String) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 1)), dispatch_get_main_queue(), { () -> Void in
                
                let resultDic = ReadJsonClass.readJsonData("sinaLogin")
                
                if resultDic.error == nil {
                    
                    if let data: AnyObject=resultDic.data {
                        
                        var user = UserModel()
                        
                        user <-- data[kData]
                        
                        subscriber.sendNext(user)
                        subscriber.sendCompleted()
                    } else {
                        
                        subscriber.sendError(NSError(
                            domain:kErrorDomain,
                            code: ErrorEnum.JSONError.errorCode,
                            userInfo: [NSLocalizedDescriptionKey:ErrorEnum.JSONError.rawValue]
                            ))
                    }
                } else {
                    
                    subscriber.sendError(resultDic.error!)
                }
            })
            return nil
        })
    }
    
    func qqLogin(qqOpenId: String) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 1)), dispatch_get_main_queue(), { () -> Void in
                
                let resultDic = ReadJsonClass.readJsonData("qqLogin")
                
                if resultDic.error == nil {
                    
                    if let data: AnyObject=resultDic.data {
                        
                        var user = UserModel()
                        
                        user <-- data[kData]
                        
                        subscriber.sendNext(user)
                        subscriber.sendCompleted()
                    } else {
                        
                        subscriber.sendError(NSError(
                            domain:kErrorDomain,
                            code: ErrorEnum.JSONError.errorCode,
                            userInfo: [NSLocalizedDescriptionKey:ErrorEnum.JSONError.rawValue]
                            ))
                    }
                } else {
                    
                    subscriber.sendError(resultDic.error!)
                }
            })
            return nil
        })
    }
    
    func saveUser(user: UserModel) {
        
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(user),forKey:kLoginUserKey)
        
        // 设置登录页面默认显示的手机号码
        if let tel = user.telephone {
            
            NSUserDefaults.standardUserDefaults().setObject(tel, forKey: kLoginPageDefaultTelephone)
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