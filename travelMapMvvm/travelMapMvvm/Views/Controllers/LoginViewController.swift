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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        setAllUIStyle()
    }
    
    // MARK: - 
    
    /**
     * 设置UIStyle
     */
    private func setAllUIStyle() {
       
        containerV.loginRadiusStyle()
        loginBtn.loginNoBorderStyle()
        registerBtn.loginBorderStyle()
        wbBtn.loginBorderStyle()
        qqBtn.loginBorderStyle()
        
        // 校验提示
        setTextFieldVaild()
    }
    
    /**
     * 设置校验提示
     */
    private func setTextFieldVaild() {
        
        // 手机号校验信号
        let isValidTelephoneSignal = self.telF.rac_textSignal().mapAs {
            (text: NSString) -> NSNumber in
            
            return self.isValidTelephone(text)
        }
        
        // 密码校验信号
        let isValidPasswordSignal = pwdF.rac_textSignal().mapAs { (password:NSString) -> NSNumber in
            
            return self.isValidPassword(password)
        }
        
        // 绑定手机号校验信号
        isValidTelephoneSignal.mapAs { (isValid:NSNumber) -> UIColor in
            
            return isValid.boolValue ? UIColor.clearColor() : UITextField.warningBackgroundColor
        }.skip(1) ~> RAC(self.telF,"backgroundColor")
        
        // 绑定密码校验信号
        isValidPasswordSignal.mapAs { (isValid:NSNumber) -> UIColor in
            
            return isValid.boolValue ? UIColor.clearColor() : UITextField.warningBackgroundColor
        }.skip(1) ~> RAC(self.pwdF,"backgroundColor")
        
        // 登录按钮校验信号
        let signUpActiveSignal = RACSignalEx.combineLatestAs([isValidTelephoneSignal,isValidPasswordSignal], reduce: { (isTelephoneVaild:NSNumber, isPasswordVaild:NSNumber) -> NSNumber in
            
            return isTelephoneVaild.boolValue && isPasswordVaild.boolValue
        })
        
        // 绑定登录按钮校验信号
        signUpActiveSignal.mapAs { (isValid:NSNumber) -> UIColor in
            
            return isValid.boolValue ? UIButton.defaultBackgroundColor : UIButton.enabledBackgroundColor
        } ~> RAC(loginBtn,"backgroundColor")
        signUpActiveSignal ~> RAC(loginBtn,"enabled")
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
