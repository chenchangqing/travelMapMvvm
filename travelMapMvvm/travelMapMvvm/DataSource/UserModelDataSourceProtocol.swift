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
     * @return 登录信号
     */
    func sinaLogin() -> RACSignal
    
    /**
     * QQ登录
     *
     * @param qqOpenId 腾讯开放平台ID
     *
     * @return 登录信号
     */
    func qqLogin(appKey:String, accessToken:String, qqOpenId:String) -> RACSignal

    /**
     * 保存登录用户信息
     *
     * @param user 用户信息
     *
     * @return
     */
    func saveUser(user:UserModel)
    
    /**
     * 清除登录用户信息
     */
    func clearUser()
    
    /**
     * 查询登录用户信息
     *
     * @return 登录用户信息
     */
    func queryUser() -> UserModel?
    
    /**
     * 查询登录页面默认显示的手机号
     */
    func queryLoginPageDefaultTelephone() -> String
    
    /**
     * 手机注册
     *
     * @param telephone 手机号码
     * @param password 用户密码
     *
     * @return  手机注册信号
     */
    func register(telephone:String, password: String) -> RACSignal
    
    /**
     * 修改密码
     *
     * @param telephone 手机号码
     * @param password 用户密码
     *
     * @return  修改密码信号
     */
    func modifyPwd(telephone: String, password: String) -> RACSignal
    
    /** 
     * 修改邮箱、昵称
     *
     * @param userId    用户ID
     * @param userName  用户昵称
     * @param email     用户邮箱
     * 
     * @return 修改邮箱、昵称信号
     */
    func modifyUInfo(userId:String, userName:String,email:String) -> RACSignal
    
    /*
     * 上传头像
     *
     * @param userId 用户ID
     * @param headImage 用户头像图片
     *
     * @return 上传头像信号
     */
    func uploadHeadImage(userId:String, headImage:UIImage) -> RACSignal
    
}