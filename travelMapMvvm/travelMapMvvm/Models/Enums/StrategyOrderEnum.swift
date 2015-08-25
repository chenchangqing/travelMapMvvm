//
//  StrategyOrderEnum.swift
//  travelMap
//
//  Created by green on 15/8/24.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit

enum StrategyOrderEnum: String {
    
    case Default    = "默认"
    case Popularity = "人气最高"
    case Download   = "下载量由最高到低"
    case New        = "最新发布"
    
    static let allValues = [Default,Popularity,Download,New]
    
    // 位置
    var index : Int {
        
        get {
            
            for var i = 0; i < StrategyOrderEnum.allValues.count; i++ {
                
                if self == StrategyOrderEnum.allValues[i] {
                    
                    return i
                }
            }
            return -1
        }
    }
    
    // 查询指定位置的元素
    static func instance(index:Int) -> StrategyOrderEnum? {
        
        if index >= 0 && index < StrategyOrderEnum.allValues.count {
            
            return StrategyOrderEnum.allValues[index]
        }
        return nil
    }
}
