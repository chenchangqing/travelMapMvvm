//
//  LoginPageParamModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/5.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit

class LoginPageParamModel: NSObject {
   
    // 登录页面已经呈现后回调
    var presentLoginPageCompletionCallback: () -> Void = {}
    
    // 登录成功后回调
    var loginSuccessCompletionCallback: () -> Void = {}
    
    init(presentLoginPageCompletionCallback:()->Void = {},loginSuccessCompletionCallback: () -> Void = {}) {
        
        self.presentLoginPageCompletionCallback = presentLoginPageCompletionCallback
        self.loginSuccessCompletionCallback = loginSuccessCompletionCallback
    }
}
