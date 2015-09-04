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
   
    // 最后一次登录的手机号码 或 刚注册后进入登录页面的手机号码
    dynamic var telephone: String = ""
    
    // 登录用户信息
    dynamic var user: UserModel?
    
    // 错误信息
    dynamic var errorMsg: String = ""
    
    // 登录命令
    var loginCommand: RACCommand!
    
    // dataSource
    private let userModelDataSourceProtocol = JSONUserModelDataSource.shareInstance()
    
    // 登录信息(根据用户输入时时更新)
    var loginTel: String = ""
    var loginPwd: String = ""
    
    // MARK: - init
    
    override init() {
        super.init()
        
        setupLoginCommand()
    }
    
    // MARK: - setup
    
    /**
     * 初始化登录命令
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
        }
    }
}
