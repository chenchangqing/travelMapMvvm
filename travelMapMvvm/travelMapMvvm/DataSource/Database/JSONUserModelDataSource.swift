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
                        
                        subscriber.sendError(ErrorEnum.JSONError.error)
                    }
                } else {
                    
                    subscriber.sendError(resultDic.error!)
                }
            })
            return nil
        })
    }
    
    func sinaLogin() -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            ShareSDK.getUserInfoWithType(ShareTypeSinaWeibo, authOptions: nil) { (result, userInfo, error) -> Void in
                
                if result {
                    
//                    DDLogDebug("uid = \(userInfo.uid())")
//                    DDLogDebug("name = \(userInfo.nickname())")
//                    DDLogDebug("icon = \(userInfo.profileImage())")
                    
                    let paramters: [String:AnyObject] = [
                        
                        "sinaOpenId" : userInfo.uid()
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
                    
                } else {
                    
                    subscriber.sendError(ErrorEnum.SinaAuthError.error)
                }
            }
            
            return nil
        })
    }
    
    func qqLogin(appKey:String, accessToken:String, qqOpenId: String) -> RACSignal {
        
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
                        
                        subscriber.sendError(ErrorEnum.JSONError.error)
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
    
    func register(telephone: String, password: String) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 3)), dispatch_get_main_queue(), { () -> Void in
                
                subscriber.sendCompleted()
            })
            
            return nil
        })
    }
    
    func modifyPwd(telephone: String, password: String) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 3)), dispatch_get_main_queue(), { () -> Void in
                
                subscriber.sendCompleted()
            })
            
            return nil
        })
    }
    
    func modifyUInfo(userId: String, userName: String, email: String) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 3)), dispatch_get_main_queue(), { () -> Void in
                
                if let loginUser = self.queryUser() {
                 
                    loginUser.email = email
                    loginUser.userName = userName
                    subscriber.sendNext(loginUser)
                }
                
                subscriber.sendCompleted()
            })
            return nil
        })
    }
    
    func uploadHeadImage(userId: String, headImage: UIImage) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 3)), dispatch_get_main_queue(), { () -> Void in
                
                subscriber.sendCompleted()
            })
            return nil
        })
    }
}