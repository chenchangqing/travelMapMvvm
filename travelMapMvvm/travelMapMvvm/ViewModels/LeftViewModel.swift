//
//  LeftViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/5.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa
import ReactiveViewModel

class LeftViewModel: ImageViewModel {
   
    // 用户登录信息
    dynamic var loginUser: UserModel?
    
    // 用户名Label文字
    dynamic var userName: String = kTextNoLoginUserName
    
    // 登录状态Label文字
    dynamic var loginStatus: String = kTextLoginAccount
    
    // 操作用户数据协议
    private let userModelDataSourceProtocol = JSONUserModelDataSource.shareInstance()
    
    // Mark: - init
    
    init() {
    
        // 初始化用户登录信息
        loginUser = userModelDataSourceProtocol.queryUser()
        
        super.init(urlString: loginUser?.userPicUrl, defaultImage: UIImage(named: "userHeader.jpg")!, isNeedCompress: true)
        
        // 设置头像
        self.urlString = loginUser?.userPicUrl
        
        // binding 
        RACObserve(self, "loginUser").subscribeNext { (user:AnyObject?) -> () in
            
            if let user=user as? UserModel {
                
                self.userName = user.userName == nil ? kTextNoLoginUserName : user.userName!
                self.loginStatus = kTextExitAccount
            } else {
                
                self.userName = kTextLoginAccount
            }
        }
        
        // 更新用户信息
        NSNotificationCenter.defaultCenter().rac_addObserverForName(kUserNotificationName, object: nil).subscribeNextAs { (notification:NSNotification) -> () in
            
            self.loginUser = notification.userInfo?[kLoginUserKey] as? UserModel
        }
    }
}
