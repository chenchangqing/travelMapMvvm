//
//  StrategyModel.swift
//  travelMap
//
//  Created by green on 15/6/23.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import ReactiveCocoa

// 攻略信息
class StrategyModel: NSObject, Deserializable {
   
    var strategyId      : String?               // 攻略ID
    var picUrl          : String?               // 攻略配图地址
    var title           : String?               // 攻略名称
    var createTime      : String?               // 创建时间 YYYY-MM-dd
    var visitNumber     : Int?                  // 浏览次数
    var author          : String?               // 小编
    var authorPicUrl    : String?               // 小编头像
    var desc            : String?               // 简介
    var likeNumber      : Int?                  // 喜欢人数
    var strategyTheme   : StrategyThemeEnum?    // 攻略主题
    var strategyMonth   : MonthEnum?            // 攻略使用的月份
    var strategyType    : StrategyTypeEnum?     // 攻略类型
    
    private var imageDataSourceProtocol = ImageDataSource.shareInstance()
    
    var requestStrategyPic  : NSURLRequest? {
        get {
            let url = isValidStrategyPicUrl()
            return url == nil ? nil : NSURLRequest(URL: url!)
        }
    }
    var requestAuthorPic    : NSURLRequest?{
        get {
            let url = isValidAuthorPicUrl()
            return url == nil ? nil : NSURLRequest(URL: url!)
        }
    }
    
    override init() {}
    
    required init(data : [String:AnyObject]) {
        
        strategyId      <-- data["strategyId"]
        picUrl          <-- data["picUrl"]
        title           <-- data["title"]
        createTime      <-- data["createTime"]
        visitNumber     <-- data["visitNumber"]
        author          <-- data["author"]
        authorPicUrl    <-- data["authorPicUrl"]
        desc            <-- data["desc"]
        likeNumber      <-- data["likeNumber"]
        
        if let strategyTheme=data["strategyTheme"] as? String {
            
            self.strategyTheme = StrategyThemeEnum(rawValue: strategyTheme)
        }
        
        if let strategyMonth=data["strategyMonth"] as? String {
            
            self.strategyMonth = MonthEnum(rawValue: strategyMonth)
        }
        
        if let strategyType=data["strategyType"] as? String {
            
            self.strategyType = StrategyTypeEnum(rawValue: strategyType)
        }
    }
    
    /**
     * 下载小编头像图片
     */
    func downloadAuthorPicImageWithUrl() -> RACSignal? {
        
        if let url = isValidAuthorPicUrl() {
            
            return imageDataSourceProtocol.downloadImageWithUrl(url)
        }
        
        return nil
    }
    
    /**
     * 下载攻略图片
     */
    func downloadStrategyPicImageWithUrl() -> RACSignal? {
        
        if let url = isValidStrategyPicUrl() {
            
            return imageDataSourceProtocol.downloadImageWithUrl(url)
        }
        
        return nil
    }
    
    /**
     * 攻略图片是否有效
     */
    private func isValidStrategyPicUrl() -> NSURL? {
        
        if let picUrl=picUrl {
            
            if let url=NSURL(string: picUrl) {
                
                return url
            }
        }
        return nil
    }
    
    /**
     * 小编头像图片是否有效
     */
    private func isValidAuthorPicUrl() -> NSURL? {
        
        
        if let picUrl=authorPicUrl {
            
            if let url=NSURL(string: picUrl) {
                
                return url
            }
        }
        return nil
    }
}
