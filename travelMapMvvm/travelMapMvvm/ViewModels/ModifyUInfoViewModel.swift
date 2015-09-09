//
//  ModifyUInfoViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/9.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa
import ReactiveViewModel

class ModifyUInfoViewModel: RVMViewModel {
    
    // MARK: - 提示信息
    
    dynamic var failureMsg  : String = ""   // 操作失败提示
    dynamic var successMsg  : String = ""   // 操作失败提示
    
    // MARK: - 文本输入内容
    
    dynamic var telephone   : String = ""   // 手机号输入框文本
    dynamic var userName    : String = ""   // 昵称输入框文本
    dynamic var email       : String = ""   // 邮箱输入框文本
    
    // MARK: - 文本输入内容校验信号
    
    var userNameValidSignal : RACSignal!    // 昵称文本校验信号
    var emailValidSignal    : RACSignal!    // 邮箱文本校验信号
    
    // MARK: - 被UI绑定的属性
    
    // buttons
    dynamic var submitBtnEnabled = false                            // 修改按钮是否可以点击
    dynamic var submitBtnBgColor = UIButton.enabledBackgroundColor  // 修改按钮背景色
    
    // textFields
    dynamic var userNameFieldBgColor    = UIColor.clearColor()
    dynamic var emailFieldBgColor       = UIColor.clearColor()
    
    // MARK: - 命令
    
    var uploadHeadImageCommand  : RACCommand!   // 上传头像命令
    var modifyUInfoCommand      : RACCommand!   // 修改昵称、邮箱命令
    
    // MARK: - VIEW MODEL
    
    var leftViewModel: LeftViewModel!       // 侧边栏数据
    
    // MARK: - init
    
    init(leftViewModel:LeftViewModel) {
        super.init()
        
        // 侧边栏数据
        self.leftViewModel = leftViewModel
        
        // 初始化文本输入内容校验信号
        setupSignals()
        
        // 初始化命令
        setupCommands()
        
        // 初始化更新UI
        setupUI()
        
        // 重置提示信息
        resetMessages()
        
        // 初始化文本内容
        setupFieldValues()
    }
    
    // MARK: - 初始化
    
    /**
     * 初始化文本输入内容校验信号
     */
    private func setupSignals() {
        
        userNameValidSignal = RACObserve(self, "userName").mapAs { (userName:NSString) -> NSNumber in
            
            return ValidHelper.isValidUsername(userName)
        }
        
        emailValidSignal = RACObserve(self, "email").mapAs { (email:NSString) -> NSNumber in
            
            return ValidHelper.isValidEmail(email)
        }
    }
    
    /**
     * 初始化命令
     */
    private func setupCommands() {
        
        uploadHeadImageCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            if let userId = self.leftViewModel.loginUser?.userId {
                
                if let headImage = any as? UIImage {
                    
                    return self.leftViewModel.userModelDataSourceProtocol.uploadHeadImage(userId, headImage: headImage)
                }
            }
            
            return RACSignal.empty()
        })
        
        modifyUInfoCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            if let userId = self.leftViewModel.loginUser?.userId {
                
                return self.leftViewModel.userModelDataSourceProtocol.modifyUInfo(userId, userName: self.userName, email: self.email)
            }
            
            return RACSignal.empty()
        })
    }
    
    /**
     * 初始化更新UI
     */
    private func setupUI() {
        
        // textFields
        userNameValidSignal.mapAs({ (isValid:NSNumber) -> UIColor in
            
            return isValid.boolValue ? UIColor.clearColor() : UITextField.warningBackgroundColor
        }) ~> RAC(self,"userNameFieldBgColor")
        
        emailValidSignal.mapAs({ (isValid:NSNumber) -> UIColor in
            
            return isValid.boolValue ? UIColor.clearColor() : UITextField.warningBackgroundColor
        }) ~> RAC(self,"emailFieldBgColor")
        
        // 修改按钮
        let submitBtnEnabledSignal = RACSignalEx.combineLatestAs([userNameValidSignal,emailValidSignal], reduce: { (userNameValid:NSNumber, emailValid:NSNumber) -> NSNumber in
            
            return userNameValid.boolValue && emailValid.boolValue
        })
        submitBtnEnabledSignal ~> RAC(self,"submitBtnEnabled")
        
        submitBtnEnabledSignal.mapAs { (enabled:NSNumber) -> UIColor in
            
            return enabled.boolValue ? UIButton.defaultBackgroundColor : UIButton.enabledBackgroundColor
        } ~> RAC(self,"submitBtnBgColor")
    }
    
    /**
     * 重置提示信息
     */
    private func resetMessages() {
        
        RACSignal.merge([
            self.modifyUInfoCommand.executionSignals,
            self.uploadHeadImageCommand.executionSignals
        ]).subscribeNext { (any:AnyObject!) -> Void in
            
            self.failureMsg = ""
            self.successMsg = ""
        }
    }
    
    /**
     * 初始化文本内容
     */
    private func setupFieldValues() {
        
        if let loginUser = leftViewModel.loginUser {
            
            if let userName = loginUser.userName {
                
                self.userName = userName
            }
            
            if let email = loginUser.email {
                
                self.email = email
            }
            
            if let telephone = loginUser.telephone {
                
                self.telephone = telephone
            }
        }
    }
}
