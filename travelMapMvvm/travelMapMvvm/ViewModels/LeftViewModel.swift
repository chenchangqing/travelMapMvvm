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
    dynamic var userName: String = kTextLoginAccount.trim()
    
    // 登录状态Label文字
    dynamic var loginStatus: String = kTextLoginAccount
    
    // 操作用户数据协议
    let userModelDataSourceProtocol = JSONUserModelDataSource.shareInstance()
    
    // Mark: - init
    
    init() {
        
        let defaultImage = UIImage(named: "userHeader.jpg")!
        
        super.init(urlString: nil, defaultImage: defaultImage, isNeedCompress: true)
        
        // 初始化用户登录信息
        loginUser = userModelDataSourceProtocol.queryUser()
        
        // binding 
        RACObserve(self, "loginUser").subscribeNext { (user:AnyObject?) -> () in
            
            // 一旦更新用户信息，则更新侧边栏信息
            if let user=user as? UserModel {
                
                self.userName = user.userName == nil ? kTextLoginAccount.trim() : user.userName!
                self.loginStatus = kTextExitAccount
                self.urlString = user.userPicUrl
                self.downloadImageCommand.execute(nil)
            } else {
                
                self.userName = kTextLoginAccount.trim()
                self.loginStatus = kTextLoginAccount
                self.urlString = nil
                self.image = defaultImage
            }
        }
        
        // 更新用户信息
        NSNotificationCenter.defaultCenter().rac_addObserverForName(kUpdateUserCompletionNotificationName, object: nil).subscribeNextAs { (notification:NSNotification) -> () in
            
            self.loginUser = notification.object as? UserModel
        }
    }
}
