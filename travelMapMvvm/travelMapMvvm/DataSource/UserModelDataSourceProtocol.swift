//
//  UserModelDataSourceProtocol.swift
//  travelMapMvvm
//
//  Created by green on 15/9/1.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa

/**
 * 操作用户数据相关
 */
protocol UserModelDataSourceProtocol {
    
    /**
     * 手机登录
     * 
     * @param telephone 手机号码
     * @param password  登录密码
     *
     * @return 登录信号
     */
    func telephoneLogin(telephone:Int,password:String) -> RACSignal
    
    /**
     * 新浪登录
     * 
     * @param sinaOpenId 新浪开放平台ID
     *
     * @return 登录信号
     */
    func sinaLogin(sinaOpenId:String) -> RACSignal
    
    /**
     * QQ登录
     *
     * @param qqOpenId 腾讯开放平台ID
     *
     * @return 登录信号
     */
    func qqLogin(qqOpenId:String) -> RACSignal
}