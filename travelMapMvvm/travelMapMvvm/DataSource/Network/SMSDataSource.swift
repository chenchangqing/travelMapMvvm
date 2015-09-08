//
//  SMSDataSource.swift
//  travelMapMvvm
//
//  Created by green on 15/9/7.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa

class SMSDataSource: SMSDataSourceProtocol {
    
    // MARK: - 单例
    
    class func shareInstance()->SMSDataSourceProtocol{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:SMSDataSource? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance=SMSDataSource()
        })
        return YRSingleton.instance!
    }
    
    func queryCountryAndAreaCode() -> CountryAndAreaCode {
        
        let result = CountryAndAreaCode()
        
        let diccodes = LocalAreaHelper.queryAreaCode() as! [String:String]
        result.countryName = diccodes["defaultCountryName"]
        result.areaCode = diccodes["defaultCode"] == nil ? "" : ("+" + diccodes["defaultCode"]!)
        
        return result
    }
    
    func queryZone() -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            var isTimeout = true
            SMS_SDK.getZone({ (state:SMS_ResponseState, zonesArray:[AnyObject]!) -> Void in
                
                isTimeout = false
                if 1 == state.value {
                    
                    subscriber.sendNext(NSMutableArray(array: zonesArray))
                    subscriber.sendCompleted()
                    
                } else {
                    
                    subscriber.sendError(ErrorEnum.GetZonesError.error)
                }
            })
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 10)), dispatch_get_main_queue(), { () -> Void in
                
                if isTimeout {
                    
                    subscriber.sendError(ErrorEnum.GetZonesError.error)
                }
            })
            
            return nil
        })
    }
    
    func isValidTelephone(telephone:String,zoneCode:String,zonesArray: NSArray) -> Bool {
        
        var isValid = false
        
        if telephone.length != 11 {
            
            return isValid
        }
        
        for(var i = 0; i < zonesArray.count ; i++) {
            
            let dict1 = zonesArray.objectAtIndex(i) as! NSDictionary
            let code1 = dict1.valueForKey("zone") as! NSString
            if code1.isEqualToString(zoneCode.stringByReplacingOccurrencesOfString("+", withString: "")) {
                
                let rule1 = dict1.valueForKey("rule") as! String
                let pred = NSPredicate(format: "SELF MATCHES %@", rule1)
                let isMatch = pred.evaluateWithObject(telephone)
                if isMatch {
                    
                    isValid = true
                }
                break
            }
        }
        
        return isValid
    }
    
    func getVerificationCodeBySMS(phoneNumber: String, zone: String) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            var isTimeout = true
            SMS_SDK.getVerificationCodeBySMSWithPhone(phoneNumber, zone: zone, result: { (error:SMS_SDKError!) -> Void in
                
                isTimeout = false
                if error != nil {
                    
                    subscriber.sendCompleted()
                } else {
                    
                    subscriber.sendError(error)
                }
            })
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 10)), dispatch_get_main_queue(), { () -> Void in
                
                if isTimeout {
                    
                    subscriber.sendError(ErrorEnum.GetZonesError.error)
                }
            })
            
            return nil
        })
    }
    
    func commitVerityCode(code: String) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            var isTimeout = true
            SMS_SDK.commitVerifyCode(code, result: { (state:SMS_ResponseState) -> Void in
                
                isTimeout = false
                if state.value == 1 {
                    
                    subscriber.sendCompleted()
                } else {
                    
                    subscriber.sendError(ErrorEnum.VerityCodeError.error)
                }
            })
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 10)), dispatch_get_main_queue(), { () -> Void in
                
                if isTimeout {
                    
                    subscriber.sendError(ErrorEnum.GetZonesError.error)
                }
            })
            
            return nil
        })
    }
}