//
//  LoginViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/4.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveViewModel

class LoginViewModel: RVMViewModel {
    
    private let userModelDataSourceProtocol = JSONUserModelDataSource.shareInstance()
    var tencentOAuth : TencentOAuth!
   
    dynamic var telephone       : String = ""   // 最后一次登录的手机号码 或 刚注册后进入登录页面的手机号码
    dynamic var user            : UserModel?    // 登录用户信息
    dynamic var errorMsg        : String = ""   // 错误信息
    
    var loginCommand            : RACCommand!   // 手机号码登录命令
    var qqBtnClickedCommand     : RACCommand!   // qq登录按钮点击后执行的命令
    var qqTencentDidLoginCommand: RACCommand!   // qq登录授权完成后执行的命令
    
    // 登录信息(根据用户输入时时更新)
    var loginTel: String = ""
    var loginPwd: String = ""
    
    
    
    // MARK: - init
    
    override init() {
        super.init()
        
        // 初始化登录页面默认显示的手机号码
        telephone = userModelDataSourceProtocol.queryLoginPageDefaultTelephone()
        
        // 初始化腾讯登录类
        self.tencentOAuth = TencentOAuth(appId: QQ_APPKEY, andDelegate: self)
        
        // 初始化手机号码登录命令
        setupLoginCommand()
        
        // 初始化qq登录按钮点击后执行的命令
        setupQQBtnClickedCommand()
        
        // 初始化qq登录授权完成后执行的命令
        setupQQTencentDidLoginCommand()
    }
    
    // MARK: - setup
    
    /**
     * 初始化手机号码登录命令
     */
    private func setupLoginCommand() {
        
        // 是否可以执行登录命令的信号
        let enabledSignal = RACObserve(self, "user").map{ (user:AnyObject?) -> NSNumber in
        
            return self.user==nil ? true : false
        }
        
        // 创建Command
        loginCommand = RACCommand(enabled: enabledSignal, signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            let intTel : Int = self.loginTel.nsString().integerValue
            return self.userModelDataSourceProtocol.telephoneLogin(intTel, password: self.loginPwd)
        })
        
        // 错误处理
        loginCommand.errors.subscribeNextAs { (error:NSError) -> () in
            
            self.errorMsg = error.localizedDescription
        }
        
        // 执行登录后，更新登录用户信息
        loginCommand.executionSignals.switchToLatest().subscribeNextAs { (user:UserModel) -> () in
            
            self.user = user
            
            // 保存登录用户信息
            self.userModelDataSourceProtocol.saveUser(user)
            
            // 发出登录成功通知
            NSNotificationCenter.defaultCenter().postNotificationName(kUpdateUserCompletionNotificationName, object: user, userInfo: nil)
        }
    }
    
    /**
     * 初始化qq登录按钮点击后执行的命令
     */
    private func setupQQBtnClickedCommand() {
        
        qqBtnClickedCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            let permissions = NSArray(objects: kOPEN_PERMISSION_GET_INFO,kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_SIMPLE_USER_INFO)
            self.tencentOAuth.authorize(permissions as [AnyObject], inSafari: false)
            
            return RACSignal.empty()
        })
    }
    
    /**
     * 初始化qq登录授权完成后执行的命令
     */
    private func setupQQTencentDidLoginCommand() {
        
        // 是否可以执行
        let enabledSignal = RACObserve(tencentOAuth, "accessToken").map { (any:AnyObject!) -> AnyObject! in
            
            return any != nil
        }
        
        // 授权失败提示
        enabledSignal.skip(1).subscribeNextAs { (enabled:Bool) -> () in
            
            if !enabled {
                
                self.errorMsg = kMsgQQAuthFailure
            }
        }
        
        // 初始化命令
        qqTencentDidLoginCommand = RACCommand(enabled: enabledSignal, signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            return self.userModelDataSourceProtocol.qqLogin(QQ_APPKEY, accessToken: self.tencentOAuth.accessToken, qqOpenId: self.tencentOAuth.openId)
        })
        
        // 错误处理
        qqTencentDidLoginCommand.errors.subscribeNextAs { (error:NSError) -> () in
            
            self.errorMsg = error.localizedDescription
        }
        
        // 执行登录后，更新登录用户信息
        qqTencentDidLoginCommand.executionSignals.switchToLatest().subscribeNextAs { (user:UserModel) -> () in
            
            self.user = user
            
            // 保存登录用户信息
            self.userModelDataSourceProtocol.saveUser(user)
            
            // 发出登录成功通知
            NSNotificationCenter.defaultCenter().postNotificationName(kUpdateUserCompletionNotificationName, object: user, userInfo: nil)
        }
    }
}
