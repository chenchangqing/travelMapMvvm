//
//  StrategyThemeEnum.swift
//  travelMap
//
//  Created by green on 15/8/23.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import Foundation

enum StrategyThemeEnum: String {
    
    case Family         = "亲子游玩"
    case Drive          = "自驾游"
    case Balloon        = "热气球"
    case Island         = "海岛控"
    case OverseasStudy  = "留学"
    case Shopping       = "扫货"
    case StarTravel     = "星旅游"
    case Yiji           = "遗迹探索"
    
    static let allValues = [Family,Drive,Balloon,Island,OverseasStudy,Shopping,Yiji]
    
    // 位置
    var index : Int {
        
        get {
            
            for var i = 0; i < StrategyThemeEnum.allValues.count; i++ {
                
                if self == StrategyThemeEnum.allValues[i] {
                    
                    return i
                }
            }
            return -1
        }
    }
    
    // 查询指定位置的元素
    static func instance(index:Int) -> StrategyThemeEnum? {
        
        if index >= 0 && index < StrategyThemeEnum.allValues.count {
            
            return StrategyThemeEnum.allValues[index]
        }
        return nil
    }
}