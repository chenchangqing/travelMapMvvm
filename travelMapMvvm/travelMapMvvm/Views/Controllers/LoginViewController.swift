//
//  LoginViewController.swift
//  travelMapMvvm
//
//  Created by green on 15/8/31.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit

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
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

}
