//
//  ForgetPwdViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/8.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveViewModel

class ForgetPwdViewModel: RVMViewModel {
    
    dynamic var failureMsg: String = ""     // 操作失败提示
    dynamic var successMsg: String = ""     // 操作失败提示
    
    dynamic var telephone   : String = ""   // 手机号输入框文本
    dynamic var password    : String = ""   // 第一个密码输入框文本
    dynamic var password2   : String = ""   // 第二个密码输入框文本
    dynamic var verifyCode  : String = ""   // 验证码输入框文本
    
    dynamic var submitBtnEnabled = false    // 修改密码按钮是否可以点击
    dynamic var sendVerifyCodeBtnEnabled = false // 发送验证码短信按钮是否可以点击
    
    // buttons背景色
    dynamic var submitBtnBgColor            = UIButton.enabledBackgroundColor
    dynamic var sendVerifyCodeBtnBgColor    = UIButton.enabledBackgroundColor
    
    // textFields背景色
    dynamic var telephoneFieldBgColor   = UIColor.clearColor()
    dynamic var passwordFieldBgColor    = UIColor.clearColor()
    dynamic var password2FieldBgColor   = UIColor.clearColor()
    dynamic var verifyCodeFieldBgColor  = UIColor.clearColor()
    
    var sendVerityCodeCommand:RACCommand!       // 发送验证码命令
    var modifyPwdCommand: RACCommand!           // 修改密码命令
    var commitVerifyCodeCommand: RACCommand!    // 验证验证码命令
    
    var telephoneSignal: RACSignal!     // 手机校验信号
    var passwordSignal: RACSignal!      // 第一个密码校验信号
    var password2Signal: RACSignal!     // 第二个密码校验信号
    var verifyCodeSignal: RACSignal!    // 验证码校验信号
    
    private let userModelDataSourceProtocol = NetworkUserModelDataSource.shareInstance()
    private let smsDataSourceProtocol       = SMSDataSource.shareInstance()
    
    override init() {
        
        super.init()
        
        // 查询默认区号
        let countryAndAreaCode = self.smsDataSourceProtocol.queryCountryAndAreaCode()
        let zoneCode = countryAndAreaCode.areaCode.stringByReplacingOccurrencesOfString("+", withString: "")
        
        // 初始化发送验证码命令
        sendVerityCodeCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            return self.smsDataSourceProtocol.getVerificationCodeBySMS(self.telephone, zone: zoneCode).materialize()
        })
        
        // 初始化修改密码命令
        modifyPwdCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            return self.userModelDataSourceProtocol.modifyPwd(self.telephone, password: self.password).materialize()
        })
        
        // 初始化验证验证码命令
        commitVerifyCodeCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            return self.smsDataSourceProtocol.commitVerityCode(self.verifyCode).materialize()
        })
        
        // 重置提示信息
        RACSignal.merge([
            sendVerityCodeCommand.executionSignals,
            modifyPwdCommand.executionSignals,
            commitVerifyCodeCommand.executionSignals
        ]).subscribeNext { (any:AnyObject!) -> Void in
            
            self.failureMsg = ""
            self.successMsg = ""
        }
        
        // 初始化校验信号
        setupSignal()
        
        // 更新UI
        updateUI()
    }
    
    /**
     * 初始化信号
     */
    private func setupSignal() {
        
        // 手机号正确
        telephoneSignal = RACObserve(self, "telephone").ignore("").mapAs { (telephone:NSString) -> NSNumber in
            
            return ValidHelper.isValidTelephone(telephone)
        }
        
        // 验证码正确
        verifyCodeSignal = RACObserve(self, "verifyCode").ignore("").mapAs { (verifyCode:NSString) -> NSNumber in
            
            return ValidHelper.isValidVerifyCode(verifyCode)
        }
        
        // 第一个密码信号
        passwordSignal = RACObserve(self, "password").ignore("").mapAs({ (password:NSString) -> NSNumber in
            
            return ValidHelper.isValidPassword(password)
        })
        
        // 第二个密码信号
        password2Signal = RACObserve(self, "password2").ignore("").mapAs({ (password:NSString) -> NSNumber in
            
            return ValidHelper.isValidPassword(password)
        })
    }
    
    /**
     * 更新UI
     */
    private func updateUI() {
        
        // 发送验证码按钮
        telephoneSignal ~> RAC(self,"sendVerifyCodeBtnEnabled")
        telephoneSignal.mapAs({ (isValid:NSNumber) -> UIColor in
            
            return isValid.boolValue ? UIButton.defaultBackgroundColor : UIButton.enabledBackgroundColor
        }) ~> RAC(self,"sendVerifyCodeBtnBgColor")
        
        // 修改密码按钮是否可以点击信号
        let submitBtnEnabledSignal = getSubmitBtnEnabledSignal()
        submitBtnEnabledSignal ~> RAC(self,"submitBtnEnabled")
        
        // 修改密码按钮背景色信号
        let submitBtnBgColorSignal = getSubmitBtnBgColorSignal()
        submitBtnBgColorSignal ~> RAC(self,"submitBtnBgColor")
        
        // 修改textField背景色
        telephoneSignal.mapAs({ (isValid:NSNumber) -> UIColor in
            
            return isValid.boolValue ? UIColor.clearColor() : UITextField.warningBackgroundColor
        }) ~> RAC(self,"telephoneFieldBgColor")
        passwordSignal.mapAs({ (isValid:NSNumber) -> UIColor in
            
            return isValid.boolValue ? UIColor.clearColor() : UITextField.warningBackgroundColor
        })    ~> RAC(self,"passwordFieldBgColor")
        password2Signal.mapAs({ (isValid:NSNumber) -> UIColor in
            
            return isValid.boolValue ? UIColor.clearColor() : UITextField.warningBackgroundColor
        })   ~> RAC(self,"password2FieldBgColor")
        verifyCodeSignal.mapAs({ (isValid:NSNumber) -> UIColor in
            
            return isValid.boolValue ? UIColor.clearColor() : UITextField.warningBackgroundColor
        })  ~> RAC(self,"verifyCodeFieldBgColor")
        
    }
    
    /**
     * 修改密码按钮是否可以点击
     */
    private func getSubmitBtnEnabledSignal() -> RACSignal {
        
        /** 手机号正确 && 验证码正确 && 2个密码正确 **/
        return RACSignal.combineLatest([
            telephoneSignal,verifyCodeSignal,passwordSignal,password2Signal
        ]).mapAs({ (tuple: RACTuple) -> NSNumber in
            
            let first   = tuple.first as! Bool
            let second  = tuple.second as! Bool
            let third   = tuple.third as! Bool
            let fourth  = tuple.fourth as! Bool
            
            let submitBtnEnabled = first && second && third && fourth
            // 密码一致
            let pwdEqual = self.password == self.password2
            
            return submitBtnEnabled && pwdEqual
        })

    }
    
    /**
     * 修改密码按钮背景色信号
     */
    private func getSubmitBtnBgColorSignal() -> RACSignal {
        
        return getSubmitBtnEnabledSignal().mapAs({ (submitBtnEnabled:NSNumber) -> UIColor in
            
            return submitBtnEnabled.boolValue ? UIButton.defaultBackgroundColor : UIButton.enabledBackgroundColor
        })
    }
    
    
}
