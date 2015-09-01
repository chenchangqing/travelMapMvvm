//
//  StrategyTypeEnum.swift
//  travelMap
//
//  Created by green on 15/8/24.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//


import Foundation

enum StrategyTypeEnum: String {
    
    case Eat        = "吃"
    case Shopping   = "购"
    case Play       = "玩"
    case Fun        = "娱"
    case Zonghe     = "综合"
    
    static let allValues = [Eat,Shopping,Play,Fun,Zonghe]
    
    // 位置
    var index : Int {
        
        get {
            
            for var i = 0; i < StrategyTypeEnum.allValues.count; i++ {
                
                if self == StrategyTypeEnum.allValues[i] {
                    
                    return i
                }
            }
            return -1
        }
    }
    
    // 查询指定位置的元素
    static func instance(index:Int) -> StrategyTypeEnum? {
        
        if index >= 0 && index < StrategyTypeEnum.allValues.count {
            
            return StrategyTypeEnum.allValues[index]
        }
        return nil
    }
    
    // 转String
    static func covertToString(array:[StrategyTypeEnum]) -> String {
        
        var result = ""
        
        for (var i=0;i<array.count;i++) {
            
            if i == array.count - 1 {
                
                result += array[i].rawValue
            } else {
                
                result += array[i].rawValue + ","
            }
        }
        return result
    }
}
