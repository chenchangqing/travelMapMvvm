//
//  NSError+Custom.swift
//  travelMapMvvm
//
//  Created by green on 15/8/29.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation

extension NSError {
    
    class func instance(method:String,errorStr:String?) -> NSError {
        
        let errorStr = errorStr == nil ? "" : errorStr!
        return NSError(domain: "[\(method):\(errorStr)]", code: -1, userInfo: nil)
    }
}