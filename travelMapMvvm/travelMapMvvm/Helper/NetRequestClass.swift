//
//  NetRequestClass.swift
//  travelMapMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import AFNetworking

/**
 * 网络请求
 */
class NetRequestClass {
    
    /**
     * 检测当前网络
     */
    class func netWorkReachabilityWithURLString(strUrl:String, callback:(isValid:Bool,status:AFNetworkReachabilityStatus) -> Void) {
        
        AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock { (status) -> Void in
            
            switch status {
            case AFNetworkReachabilityStatus.Unknown:
                
                callback(isValid: false, status: status)
                break
            case AFNetworkReachabilityStatus.NotReachable:
                
                callback(isValid: false, status: status)
                break
            case AFNetworkReachabilityStatus.ReachableViaWiFi:
                
                callback(isValid: true, status: status)
                break
            case AFNetworkReachabilityStatus.ReachableViaWWAN:
                
                callback(isValid: true, status: status)
                break
            default:
                
                callback(isValid: false, status: status)
                break
            }
        }
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
    }
    
    /**
     * POST请求
     */
    class func netRequestPOSTWithRequestURL(
        callback:NetReuqestCallBack,
        requestURlString:String,
        parameters:[String:AnyObject]=[String:AnyObject]()) {
            
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html","text/plain"]) as Set<NSObject>

        manager.POST(requestURlString, parameters: parameters, success: { (operation, responseObj) -> Void in
            
            let resultDic = responseObj as! [NSObject:AnyObject]
            
            let success = resultDic[kSuccess] as? Bool
            let msg     = (resultDic[kMsg] as? String) == nil ? "" : ":" + (resultDic[kMsg] as? String)!
            let data: AnyObject?    = resultDic[kData]
            
            if let success=success {
                
                callback(error: nil, data: data)
            } else {
                
                callback(error:NSError(
                    domain: ErrorEnum.ServerError.errorDommain,
                    code: ErrorEnum.ServerError.errorCode,
                    userInfo: [NSLocalizedDescriptionKey:ErrorEnum.ServerError.rawValue + msg]),data:nil)
            }
            
            }) { (operation, error) -> Void in
                
                callback(error:error, data: nil)
            }
    }
    
    /**
     * GET请求
     */
    class func netRequestGETWithRequestURL(
        callback:NetReuqestCallBack,
        requestURlString:String,
        parameters:[String:AnyObject]=[String:AnyObject]()) {
            
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html","text/plain"]) as Set<NSObject>
        
        manager.POST(requestURlString, parameters: parameters, success: { (operation, responseObj) -> Void in
            
            let resultDic = responseObj as! [NSObject:AnyObject]
            
            let success = resultDic[kSuccess] as? Bool
            let msg     = (resultDic[kMsg] as? String) == nil ? "" : ":" + (resultDic[kMsg] as? String)!
            let data: AnyObject?    = resultDic[kData]
            
            if let success=success {
                
                callback(error: nil, data: data)
            } else {
                
                
                callback(error:NSError(
                    domain: ErrorEnum.ServerError.errorDommain,
                    code: ErrorEnum.ServerError.errorCode,
                    userInfo: [NSLocalizedDescriptionKey:ErrorEnum.ServerError.rawValue + msg]),data:nil)
            }
            
        }) { (operation, error) -> Void in
            
            callback(error:error, data: nil)
        }
            
    }
}