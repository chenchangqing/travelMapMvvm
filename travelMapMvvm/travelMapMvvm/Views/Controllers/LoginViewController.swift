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
    
    var isValidTelSignal:RACSignal!             // 手机号校验信号
    var isValidPwdSignal :RACSignal!            // 密码校验信号
    var commandExecutingSignal: RACSignal!      // 组合命令正在执行信号
    
    private let loginViewModel = LoginViewModel()
    
    // 登录成功后回调
    var loginSuccessCompletionCallback: () -> Void = {}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        setup()
    }
    
    // MARK: - setup
    
    private func setup() {
        
        setAllUIStyle()
        setupValids()
        setupTextFields()
        setupTelephoneLoginBtn()
        setupRegisterBtn()
        setupSinaLoginBtn()
        setupQQLoginBtn()
        setupMessage()
        setupProcessLoginSuccess()
        
    }
    
    // ------ ------ ------ ------ ------ ------ ------ ------ ------ ------
    
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
     * 校验信号设置
     */
    private func setupValids() {
        
        // 手机号校验信号
        isValidTelSignal = self.telF.rac_textSignal().mapAs {
            (text: NSString) -> NSNumber in
            
            return self.isValidTelephone(text)
        }
        
        // 密码校验信号
        isValidPwdSignal = pwdF.rac_textSignal().mapAs { (password:NSString) -> NSNumber in
            
            return self.isValidPassword(password)
        }
        
        // 组合命令正在执行信号
        commandExecutingSignal = RACSignal.combineLatest([
            loginViewModel.loginCommand.executing
            ,loginViewModel.qqBtnClickedCommand.executing
            ,loginViewModel.qqTencentDidLoginCommand.executing
            ,loginViewModel.sinaBtnClickedCommand.executing
        ]).mapAs({ (tuple: RACTuple) -> NSNumber in
            
            let first   = tuple.first as! Bool
            let second  = tuple.second as! Bool
            let third   = tuple.third as! Bool
            let fourth  = tuple.fourth as! Bool
            
            let isLoading = first || second || third || fourth
            
            return isLoading
        })
    }

    /**
     * 文本框设置
     */
    private func setupTextFields() {
        
        // 默认手机号码
        RACObserve(loginViewModel, "telephone") ~> RAC(telF,"text")
        
        // 绑定手机号输入框背景色
        isValidTelSignal.mapAs { (isValid:NSNumber) -> UIColor in
            
            return isValid.boolValue ? UIColor.clearColor() : UITextField.warningBackgroundColor
        }.skip(1) ~> RAC(self.telF,"backgroundColor")
        
        // 绑定密码输入框背景色
        isValidPwdSignal.mapAs { (isValid:NSNumber) -> UIColor in
            
            return isValid.boolValue ? UIColor.clearColor() : UITextField.warningBackgroundColor
        }.skip(1) ~> RAC(self.pwdF,"backgroundColor")
        
        //时时更新loginViewModel的登录信息
        telF.rac_textSignal() ~> RAC(self.loginViewModel, "loginTel")
        pwdF.rac_textSignal() ~> RAC(self.loginViewModel, "loginPwd")
    }
    
    /**
     * 手机登录按钮设置
     */
    private func setupTelephoneLoginBtn() {
        
        // 如果有默认手机号，设置手机号文本框没有背景色
        let subscriber = RACSubject()
        isValidTelSignal.subscribe(subscriber)
        if isValidTelephone(telF.text) {
            
            subscriber.sendNext(true)
        }
        
        // 临时信号
        let tempSignal = RACSignal.combineLatest([isValidTelSignal,isValidPwdSignal,commandExecutingSignal]).mapAs { (tuple: RACTuple) -> NSNumber in
            
            return (tuple.first as! Bool) && (tuple.second as! Bool) && !(tuple.third as! Bool)
        }
        
        // 绑定按钮enabled
        tempSignal ~> RAC(loginBtn,"enabled")
        
        // 绑定按钮backgroundColor
        tempSignal.mapAs { (enabled:NSNumber) -> UIColor in
            
            return enabled.boolValue ? UIButton.defaultBackgroundColor : UIButton.enabledBackgroundColor
        } ~> RAC(loginBtn,"backgroundColor")
        
        // 绑定事件
        loginBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNextAs { (sender:UIButton) -> () in
            
            self.view.endEditing(true)
            self.loginViewModel.loginCommand.execute(nil)
        }
    }
    
    /**
     * 注册按钮登录设置
     */
    private func setupRegisterBtn() {
        
        // 绑定按钮enabled
        
        // 绑定按钮backgroundColor
        
        // 绑定事件
    }
    
    /**
     * 新浪登录按钮设置
     */
    private func setupSinaLoginBtn() {
        
        // 绑定按钮enabled
        commandExecutingSignal.mapAs({ (isExecuting:NSNumber) -> NSNumber in
            return !isExecuting.boolValue
        }) ~> RAC(wbBtn,"enabled")
        
        // 绑定按钮backgroundColor
        commandExecutingSignal.mapAs { (isExecuting:NSNumber) -> UIColor in
            
            return !isExecuting.boolValue ? UIButton.defaultBackgroundColor : UIButton.enabledBackgroundColor
        } ~> RAC(wbBtn,"backgroundColor")
        
        // 绑定事件
        wbBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (any:AnyObject!) -> Void in
            
            self.view.endEditing(true)
            self.loginViewModel.sinaBtnClickedCommand.execute(nil)
        }
    }
    
    /**
     * 腾讯登录按钮设置
     */
    private func setupQQLoginBtn() {
        
        // 是否安装了QQ的信号
        let iphoneQQInstalledSignal = RACSignal.createSignal { (subscriber:RACSubscriber!) -> RACDisposable! in
            
            subscriber.sendNext(TencentOAuth.iphoneQQInstalled())
            subscriber.sendCompleted()
            return nil
        }
        
        // 临时信号
        let tempSignal = RACSignal.combineLatest([iphoneQQInstalledSignal,commandExecutingSignal]).mapAs { (tuple: RACTuple) -> NSNumber in
            
            return (tuple.first as! Bool) && !(tuple.second as! Bool)
        }
        
        // 绑定按钮enabled
        tempSignal ~> RAC(qqBtn,"enabled")
        
        // 绑定按钮backgroundColor
        tempSignal.mapAs { (enabled:NSNumber) -> UIColor in
            
            return enabled.boolValue ? UIButton.defaultBackgroundColor : UIButton.enabledBackgroundColor
        } ~> RAC(qqBtn,"backgroundColor")
        
        // 绑定事件
        qqBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (any:AnyObject!) -> Void in
            
            self.view.endEditing(true)
            self.loginViewModel.qqBtnClickedCommand.execute(nil)
        }
    }
    
    /**
     * 提示设置
     */
    private func setupMessage() {
        
        // 已经登录提示
        RACSignalEx.combineLatestAs([loginViewModel.loginCommand.enabled.skip(1),loginBtn.rac_signalForControlEvents( UIControlEvents.TouchUpInside)], reduce: { (canExecute:Bool, sender:UIButton) -> NSNumber in

            return !canExecute
        }).subscribeNextAs { (canShowError:Bool) -> () in

            if canShowError {
                self.showHUDErrorMessage(kMsgLogined)
            }
        }

        RACSignal.combineLatest([commandExecutingSignal,RACObserve(loginViewModel, "errorMsg")]).subscribeNextAs { (tuple: RACTuple) -> () in

            let isLoading = tuple.first as! Bool
            let errorMsg  = tuple.second as! String
            
            if isLoading {
                
                self.showHUDIndicator()
            } else {
                
                if errorMsg.isEmpty {
                    
                    self.hideHUD()
                }
            }
            
            if !errorMsg.isEmpty {
                
                self.showHUDErrorMessage(errorMsg)
            }
        }
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

    // ------ ------ ------ ------ ------ ------ ------ ------ ------ ------
    
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
