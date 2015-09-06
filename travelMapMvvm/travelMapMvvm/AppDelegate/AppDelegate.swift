//
//  AppDelegate.swift
//  CJMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // dataSource
    private let userModelDataSourceProtocol = JSONUserModelDataSource.shareInstance()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 如果需要显示网络活动指示器，可以用下面方法
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
        
        // 注册登录、退出通知
        registerPresentLoginPageActionNotification()
        registerPresentLoginPageActionExitLoginNotification()
        
        // 集成Mob
        registerMob()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        return TencentOAuth.HandleOpenURL(url)
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        return TencentOAuth.HandleOpenURL(url)
    }
    
    // MARK: - notification
    
    /**
     * 通过系统通知弹出登录页面
     */
    func registerPresentLoginPageActionNotification() {
        
        // 通过系统通知弹出登录页面
        NSNotificationCenter.defaultCenter().rac_addObserverForName(kPresentLoginPageActionNotificationName, object: nil).subscribeNextAs { (notification:NSNotification) -> () in
            
            // 通知参数
            let loginPageParam = notification.object as? LoginPageParamModel == nil ? LoginPageParamModel() :  notification.object as! LoginPageParamModel
            
            if let loginUser = self.userModelDataSourceProtocol.queryUser() {
                
                // 已经登录，执行登录成功回调
                loginPageParam.loginSuccessCompletionCallback()
                
            } else {
                
                // 没有登录，呈现登录页面
                let loginViewControllerNav = UIViewController.getViewController("Login", identifier: "LoginViewControllerNav") as! UINavigationController
                
                // 设置登录成功回调
                (loginViewControllerNav.topViewController as! LoginViewController).loginSuccessCompletionCallback = loginPageParam.loginSuccessCompletionCallback
                
                self.window?.rootViewController?.presentViewController(loginViewControllerNav, animated: true, completion: { () -> Void in
                    
                    // 呈现登录页面后，执行呈现登录页面回调
                    loginPageParam.presentLoginPageCompletionCallback()
                })
            }
        }
    }
    
    /**
     * 通过系统通知登录或退出
     */
    func registerPresentLoginPageActionExitLoginNotification() {
        
        // 通过系统通知弹出登录页面
        NSNotificationCenter.defaultCenter().rac_addObserverForName(kPresentLoginPageActionExitLoginNotificationName, object: nil).subscribeNextAs { (notification:NSNotification) -> () in
            
            // 通知参数
            let loginPageParam = notification.object as? LoginPageParamModel == nil ? LoginPageParamModel() :  notification.object as! LoginPageParamModel
            
            if let loginUser = self.userModelDataSourceProtocol.queryUser() {
                
                // 已经登录，直接退出
                self.userModelDataSourceProtocol.clearUser()
                
                // 发出退出登录通知（比如可以更新侧边栏信息）
                NSNotificationCenter.defaultCenter().postNotificationName(kUpdateUserCompletionNotificationName, object: nil, userInfo: nil)
                
                // 注销登录后回调
                loginPageParam.exitLoginSuccessCompletionCallback()
                
            } else {
                
                // 没有登录，呈现登录页面
                let loginViewControllerNav = UIViewController.getViewController("Login", identifier: "LoginViewControllerNav") as! UINavigationController
                
                // 设置登录成功回调
                (loginViewControllerNav.topViewController as! LoginViewController).loginSuccessCompletionCallback = loginPageParam.loginSuccessCompletionCallback
                
                self.window?.rootViewController?.presentViewController(loginViewControllerNav, animated: true, completion: { () -> Void in
                    
                    // 呈现登录页面后，执行呈现登录页面回调
                    loginPageParam.presentLoginPageCompletionCallback()
                })
            }
        }
    }

    /**
     * 集成Mob
     */
    func registerMob() {
        
        //添加新浪微博应用
        ShareSDK.connectSinaWeiboWithAppKey(SINA_APPKEY, appSecret: SINA_APPSECRET, redirectUri: SINA_REDIRECTURL)
        
        // 添加QQ应用
        ShareSDK.connectQQWithQZoneAppKey(QQ_APPKEY, qqApiInterfaceCls: QQApiInterface.self, tencentOAuthCls: TencentOAuth.self)
    }

}

