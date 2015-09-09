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
        
        return String(telephoneStr).length == 11
    }
    
    /**
     * 校验密码
     */
    class func isValidPassword(password:NSString) -> Bool {
        
        return String(password).length > 0
    }
    
    /**
     * 校验验证码
     */
    class func isValidVerifyCode(verifyCode:NSString) -> Bool {
        
        return String(verifyCode).length == 4
    }
    
    /**
     * 校验用户名
     */
    class func isValidUsername(userName:NSString) -> Bool {
        
        return String(userName).length > 0
    }
    
    /**
     * 校验邮箱
     */
    class func isValidEmail(email:NSString) -> Bool {
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
        return predicate.evaluateWithObject(email)
    }
}
