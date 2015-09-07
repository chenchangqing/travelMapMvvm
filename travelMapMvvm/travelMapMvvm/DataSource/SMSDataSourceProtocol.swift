//
//  SMSDataSourceProtocol.swift
//  travelMapMvvm
//
//  Created by green on 15/9/7.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa

protocol SMSDataSourceProtocol {
    
    /**
     * 查询默认国家名称和国家码
     *
     * @return 默认国家名称国家码
     */
    func queryCountryAndAreaCode() -> CountryAndAreaCode
    
    /**
     * 获取支持区号
     *
     * @return 获取支持区号信号
     */
    func queryZone() -> RACSignal
    
    /**
     * 校验手机号码
     *  
     * @param telephone 手机号
     * @param zoneCode 区号
     * @param areaArray 支持的区号数组
     *
     * @return 是否有效
     */
    func isValidTelephone(telephone:String,zoneCode:String,zonesArray: NSArray) -> Bool
    
    /**
     * 获取验证码
     *
     * @phoneNumber 手机号
     * @zone 国家码
     *
     * @return 获取验证码信号
     */
    func getVerificationCodeBySMS(phoneNumber: String, zone: String) -> RACSignal
    
    /**
     * 提交验证码校验
     *
     * @param code 验证码
     *
     * @return 提交验证码校验
     */
    func commitVerityCode(code:String) -> RACSignal
}