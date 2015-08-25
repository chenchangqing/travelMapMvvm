//
//  MonthEnum.swift
//  travelMap
//
//  Created by green on 15/8/23.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import Foundation

enum MonthEnum : String {
    
    case January        = "一月"
    case February       = "二月"
    case March          = "三月"
    case April          = "四月"
    case May            = "五月"
    case June           = "六月"
    case July           = "七月"
    case August         = "八月"
    case September      = "九月"
    case October        = "十月"
    case November       = "十一月"
    case December       = "十二月"
    
    static let allValues = [January,February,March,April,May,June,July,August,September,October,November,December]
    
    // 位置
    var index : Int {
        
        get {
            
            for var i = 0; i < MonthEnum.allValues.count; i++ {
                
                if self == MonthEnum.allValues[i] {
                    
                    return i
                }
            }
            return -1
        }
    }
    
    // 查询指定位置的元素
    static func instance(index:Int) -> MonthEnum? {
        
        if index >= 0 && index < MonthEnum.allValues.count {
            
            return MonthEnum.allValues[index]
        }
        return nil
    }
}