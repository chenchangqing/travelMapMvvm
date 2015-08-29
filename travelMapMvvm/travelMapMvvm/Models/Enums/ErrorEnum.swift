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
    
    static let allValues = [ServerError,JSONError,ImageDownloadError]
    
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
    
    // 错误域
    var errorDommain:String  {
        
        get {
            
            return "com.city8.go"
        }
    }
    
    // errorCode
    var errorCode: Int {
        
        get {
            
            return -1000 - index
        }
    }
}