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
    
    // 用户操作类
    private let userModelDataSourceProtocol = JSONUserModelDataSource.shareInstance()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 如果需要显示网络活动指示器，可以用下面方法
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
        
        // 同意通过系统通知弹出登录页面
        NSNotificationCenter.defaultCenter().rac_addObserverForName(kPresentLoginPageActionNotificationName, object: nil).subscribeNextAs { (notification:NSNotification) -> () in
            
            if let loginPageParam = notification.object as? LoginPageParamModel {
                
                if let loginUser = self.userModelDataSourceProtocol.queryUser() {
                    
                    loginPageParam.loginSuccessCompletionCallback()
                } else {
                    
                    let loginViewControllerNav = UIViewController.getViewController("Login", identifier: "LoginViewControllerNav")!
                    
                    self.window?.rootViewController?.presentViewController(loginViewControllerNav, animated: true, completion: { () -> Void in
                        
                        loginPageParam.presentLoginPageCompletionCallback()
                    })
                }
            }
        }
        
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


}

