//
//  ValidHelper.swift
//  travelMapMvvm
//
//  Created by green on 15/9/8.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit

class ValidHelper: NSObject {
    
    
    /**
     * 校验手机号
     */
    class func isValidTelephone(telephoneStr:NSString) -> Bool {
        
        return telephoneStr.length == 11
    }
    
    /**
     * 校验密码
     */
    class func isValidPassword(password:NSString) -> Bool {
        
        return password.length > 0
    }
    
    /**
     * 校验验证码
     */
    class func isValidVerifyCode(verifyCode:NSString) -> Bool {
        
        return verifyCode.length == 4
    }
}
