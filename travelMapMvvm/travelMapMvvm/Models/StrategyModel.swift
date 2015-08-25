//
//  StrategyModel.swift
//  travelMap
//
//  Created by green on 15/6/23.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit

// 攻略信息
class StrategyModel: NSObject {
   
    var strategyId      : String?               // 攻略ID
    var picUrl          : String?               // 攻略配图地址
    var title           : String?               // 攻略名称
    var createTime      : String?               // 创建时间 YYYY-MM-dd
    var visitNumber     : String?               // 浏览次数
    var author          : String?               // 小编
    var authorPicUrl    : String?               // 小编头像
    var desc            : String?               // 简介
    var likeNumber      : String?               // 喜欢人数
    var strategyTheme   : StrategyThemeEnum?    // 攻略主题
    var strategyMonth   : MonthEnum?            // 攻略使用的月份
    var strategyType    : StrategyTypeEnum?     // 攻略类型
    
    init(dictionary: [String:AnyObject]) {
        
        // kvc
        super.init()
        self.setValuesForKeysWithDictionary(dictionary)
        
    }
    
    /**
     * kvc 特殊处理
     */
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if key == kStrategyTheme {
            
            
            if let strategyTheme = value as? Int {
                
                self.strategyTheme = StrategyThemeEnum.instance(strategyTheme)
            }
        }
        
        if key == kStrategyMonth {
            
            if let strategyMonth = value as? Int {
                
                self.strategyMonth = MonthEnum.instance(strategyMonth)
            }
        }
        
        if key == kStrategyType {
            
            if let strategyType = value as? Int {
                
                self.strategyType = StrategyTypeEnum.instance(strategyType)
            }
        }
    }
}
