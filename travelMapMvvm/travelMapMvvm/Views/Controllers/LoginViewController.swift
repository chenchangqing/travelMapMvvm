//
//  LoginViewController.swift
//  travelMapMvvm
//
//  Created by green on 15/8/31.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import ReactiveCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var containerV: UIView!      // 容器
    @IBOutlet weak var loginBtn: UIButton!      // 登录按钮
    @IBOutlet weak var registerBtn: UIButton!   // 注册按钮
    @IBOutlet weak var wbBtn: UIButton!         // 微博登录
    @IBOutlet weak var qqBtn: UIButton!         // 腾讯登录
    
    @IBOutlet weak var telF: UITextField!       // 手机号文本框
    @IBOutlet weak var pwdF: UITextField!       // 密码文本框
    
    private let loginViewModel = LoginViewModel()
    
    // 登录成功后回调
    var loginSuccessCompletionCallback: () -> Void = {}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        setup()
    }
    
    // MARK: - 
    
    private func setup() {
        
        setAllUIStyle()
        
        // 手机号校验信号
        let isValidTelephoneSignal = self.telF.rac_textSignal().mapAs {
            (text: NSString) -> NSNumber in
            
            return self.isValidTelephone(text)
        }
        
        // 密码校验信号
        let isValidPasswordSignal = pwdF.rac_textSignal().mapAs { (password:NSString) -> NSNumber in
            
            return self.isValidPassword(password)
        }
        
        // setup
        
        // 设置错误输入提示背景
        setupTextFieldBgColor(isValidTelephoneSignal,isValidPasswordSignal: isValidPasswordSignal)
        
        // 设置手机登录按钮是否可以点击以及不可点击时的颜色
        setupTelLoginBtnBgColor(isValidTelephoneSignal,isValidPasswordSignal: isValidPasswordSignal)
        
        setupdateViewModelLoginInfo()   // 时时更新loginViewModel的登录信息
        setupProcessLoginSuccess()      // 处理登录成功
        setupMessage()                  // 登录提示
        
        // 手机登录event
        loginBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNextAs { (sender:UIButton) -> () in
            
            self.view.endEditing(true)
            self.loginViewModel.loginCommand.execute(nil)
        }
        
        // 默认手机号码
        RACObserve(loginViewModel, "telephone") ~> RAC(telF,"text")
        
        // qq登录设置
        setupQQ()
    }
    
    /**
     * 设置UIStyle
     */
    private func setAllUIStyle() {
       
        // ui style
        containerV.loginRadiusStyle()
        loginBtn.loginNoBorderStyle()
        registerBtn.loginBorderStyle()
        wbBtn.loginBorderStyle()
        qqBtn.loginBorderStyle()
    }
    
    /**
     * 设置错误输入提示背景
     */
    private func setupTextFieldBgColor(isValidTelephoneSignal:RACSignal,isValidPasswordSignal:RACSignal) {
        
        // 手机号输入框
        isValidTelephoneSignal.mapAs { (isValid:NSNumber) -> UIColor in
            
            return isValid.boolValue ? UIColor.clearColor() : UITextField.warningBackgroundColor
        }.skip(1) ~> RAC(self.telF,"backgroundColor")
        
        // 密码输入框
        isValidPasswordSignal.mapAs { (isValid:NSNumber) -> UIColor in
            
            return isValid.boolValue ? UIColor.clearColor() : UITextField.warningBackgroundColor
        }.skip(1) ~> RAC(self.pwdF,"backgroundColor")
    }
    
    /** 
     * 设置手机登录按钮是否可以点击以及不可点击时的颜色
     */
    private func setupTelLoginBtnBgColor(isValidTelephoneSignal:RACSignal,isValidPasswordSignal:RACSignal) {
        
        // bind登录按钮校验信号
        let signUpActiveSignal = RACSignal.combineLatest([isValidTelephoneSignal,isValidPasswordSignal,loginViewModel.loginCommand.executing]).mapAs {
            (tuple: RACTuple) -> NSNumber in
            
            return (tuple.first as! Bool) && (tuple.second as! Bool) && !(tuple.third as! Bool)
        }
            
        signUpActiveSignal.mapAs { (isValid:NSNumber) -> UIColor in
            
            return isValid.boolValue ? UIButton.defaultBackgroundColor : UIButton.enabledBackgroundColor
        } ~> RAC(loginBtn,"backgroundColor")
        
        signUpActiveSignal ~> RAC(loginBtn,"enabled")
        
        // 聚焦手机号输入
        telF.becomeFirstResponder()
    }
    
    /**
     * 时时更新loginViewModel的登录信息
     */
    private func setupdateViewModelLoginInfo() {
        
        telF.rac_textSignal() ~> RAC(self.loginViewModel, "loginTel")
        pwdF.rac_textSignal() ~> RAC(self.loginViewModel, "loginPwd")
    }
    
    /**
     * 处理登录成功
     */
    private func setupProcessLoginSuccess() {
        
        RACObserve(loginViewModel, "user").ignore(nil).subscribeNextAs { (user:UserModel!) -> () in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            UIApplication.sharedApplication().delegate?.window?!.rootViewController?.showHUDMessage(kMsgLoginSuccess)
            self.loginSuccessCompletionCallback()
        }
    }
    
    /**
     * 登录提示
     */
    private func setupMessage() {
        
        // loading and errorMsg
        RACSignal.combineLatest([
            loginViewModel.loginCommand.executing
            ,loginViewModel.qqBtnClickedCommand.executing
            ,loginViewModel.qqTencentDidLoginCommand.executing
            ,RACObserve(loginViewModel, "errorMsg")
        ]).subscribeNext { (tuple:AnyObject!) -> Void in
            
            let tuple = tuple as! RACTuple
            
            let first = tuple.first as! Bool
            let second = tuple.second as! Bool
            let third = tuple.third as! Bool
            let fourth = tuple.fourth as! String
            
            let isLoading = first || second || third
            
            if isLoading {
                
                self.showHUDIndicator()
            } else {
                
                if fourth.isEmpty {
                    
                    self.hideHUD()
                }
            }
            
            if !fourth.isEmpty {
                
                self.showHUDErrorMessage(fourth)
            }
        }
        
        // 已经登录提示
        RACSignalEx.combineLatestAs([loginViewModel.loginCommand.enabled.skip(1),loginBtn.rac_signalForControlEvents( UIControlEvents.TouchUpInside)], reduce: { (canExecute:Bool, sender:UIButton) -> NSNumber in
            
            return !canExecute
        }).subscribeNextAs { (canShowError:Bool) -> () in
            
            if canShowError {
                self.showHUDErrorMessage(kMsgLogined)
            }
        }
    }
    
    /**
     * qq登录设置
     */
    private func setupQQ() {
        
        // 是否安装了QQ的信号
        let iphoneQQInstalledSignal = RACSignal.createSignal { (subscriber:RACSubscriber!) -> RACDisposable! in
            
            subscriber.sendNext(TencentOAuth.iphoneQQInstalled())
            subscriber.sendCompleted()
            return nil
        }
        
        // bind登录按钮校验信号
        let qqSignUpActiveSignal = RACSignal.combineLatest([iphoneQQInstalledSignal,loginViewModel.qqBtnClickedCommand.executing,loginViewModel.qqTencentDidLoginCommand.executing]).mapAs {
            (tuple: RACTuple) -> NSNumber in
            
            return (tuple.first as! Bool) && !(tuple.second as! Bool) && !(tuple.third as! Bool)
        }
        
        // 绑定QQ登录按钮背景色
        qqSignUpActiveSignal.mapAs { (isCanClick:NSNumber) -> UIColor in
            
            return isCanClick.boolValue ? UIButton.defaultBackgroundColor : UIButton.enabledBackgroundColor
        } ~> RAC(qqBtn,"backgroundColor")
        
        // 绑定QQ登录按钮是否可用
        qqSignUpActiveSignal ~> RAC(self.qqBtn,"enabled")
        
        // 事件
        qqBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (any:AnyObject!) -> Void in
            
            self.view.endEditing(true)
            self.loginViewModel.qqBtnClickedCommand.execute(nil)
        }
    }

    // MARK: - Valid
    
    /**
     * 校验手机号
     */
    private func isValidTelephone(telephoneStr:NSString) -> Bool {
        
        return telephoneStr.length == 11
    }
    
    /**
     * 校验密码
     */
    private func isValidPassword(password:NSString) -> Bool {
        
        return password.length > 0
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    @IBAction func unwindSegueToLoginViewController(segue: UIStoryboardSegue) {
    
    }

}
