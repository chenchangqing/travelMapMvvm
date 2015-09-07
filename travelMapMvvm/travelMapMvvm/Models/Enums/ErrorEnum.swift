//
//  ErrorEnum.swift
//  travelMapMvvm
//
//  Created by green on 15/8/29.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation

enum ErrorEnum : String {
    
    case ServerError = "服务器错误"
    case JSONError = "JSON转换错误"
    case ImageDownloadError = "图片下载失败"
    case SinaAuthError = "新浪登录授权失败"
    case GetZonesError = "获取支持区号失败"
    case VerityCodeError = "手机验证码错误"
    
    static let allValues = [ServerError,JSONError,ImageDownloadError,SinaAuthError,GetZonesError,VerityCodeError]
    
    // 位置
    var index : Int {
        
        get {
            
            for var i = 0; i < ErrorEnum.allValues.count; i++ {
                
                if self == ErrorEnum.allValues[i] {
                    
                    return i
                }
            }
            return -1
        }
    }
    
    // 查询指定位置的元素
    static func instance(index:Int) -> ErrorEnum? {
        
        if index >= 0 && index < ErrorEnum.allValues.count {
            
            return ErrorEnum.allValues[index]
        }
        return nil
    }
    
    // errorCode
    var errorCode: Int {
        
        get {
            
            return -1000 - index
        }
    }
    
    var error: NSError {
        
        get {
            
            return NSError(domain: kErrorDomain, code: self.errorCode, userInfo: [NSLocalizedDescriptionKey:self.rawValue])
        }
    }
}