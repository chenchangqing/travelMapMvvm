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
    
    // Contant
    private let kIsLogined = "用户已经登录"

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
        setupLoginMessage()             // 登录提示
        
        // 手机登录event
        loginBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNextAs { (sender:UIButton) -> () in
            
            self.view.endEditing(true)
            self.loginViewModel.loginCommand.execute(nil)
        }
        
        // 默认手机号码
        RACObserve(loginViewModel, "telephone") ~> RAC(telF,"text")
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
            
            println(user)
        }
    }
    
    /**
     * 登录提示
     */
    private func setupLoginMessage() {
        
        loginViewModel.loginCommand.executing.subscribeNextAs { (isExecuting:Bool) -> () in
            
            if isExecuting {
                
                self.showHUDIndicator()
                
            } else {
                
                if !self.loginViewModel.errorMsg.isEmpty {
                    
                    self.showHUDErrorMessage(self.loginViewModel.errorMsg)
                } else {
                    
                    self.hideHUD()
                }
            }
        }
        
        RACSignalEx.combineLatestAs([loginViewModel.loginCommand.enabled.skip(1),loginBtn.rac_signalForControlEvents( UIControlEvents.TouchUpInside)], reduce: { (canExecute:Bool, sender:UIButton) -> NSNumber in
            
            return !canExecute
        }).subscribeNextAs { (canShowError:Bool) -> () in
            
            if canShowError {
                self.showHUDErrorMessage(self.kIsLogined)
            }
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
