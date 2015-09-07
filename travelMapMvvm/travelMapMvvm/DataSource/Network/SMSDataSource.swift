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
        result.countryName = diccodes["defaultCode"]
        result.areaCode = diccodes["defaultCountryName"]
        
        return result
    }
    
    func queryZone() -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            SMS_SDK.getZone({ (state:SMS_ResponseState, zonesArray:[AnyObject]!) -> Void in
                
                if 1 == state.value {
                    
                    subscriber.sendNext(zonesArray)
                    subscriber.sendCompleted()
                    
                } else {
                    
                    subscriber.sendError(ErrorEnum.GetZonesError.error)
                }
            })
            
            return nil
        })
    }
    
    func isValidTelephone(telephone:String,zoneCode:String,zonesArray: NSArray) -> Bool {
        
        var isValid = false
        
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
            
            SMS_SDK.getVerificationCodeBySMSWithPhone(phoneNumber, zone: zone, result: { (error:SMS_SDKError!) -> Void in
                
                if error != nil {
                    
                    subscriber.sendCompleted()
                } else {
                    
                    subscriber.sendError(error)
                }
            })
            
            return nil
        })
    }
    
    func commitVerityCode(code: String) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            SMS_SDK.commitVerifyCode(code, result: { (state:SMS_ResponseState) -> Void in
                
                if state.value == 1 {
                    
                    subscriber.sendCompleted()
                } else {
                    
                    subscriber.sendError(ErrorEnum.VerityCodeError.error)
                }
            })
            
            return nil
        })
    }
}