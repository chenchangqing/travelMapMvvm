//
//  ShowPoiModeEnum.swift
//  travelMap
//
//  Created by green on 15/8/24.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import Foundation

enum ShowPoiModeEnum : String {
    
    case Map  = "地图"
    case List = "列表"
    
    static let allValues = [Map,List]
    
    // 位置
    var index : Int {
        
        get {
            
            for var i = 0; i < ShowPoiModeEnum.allValues.count; i++ {
                
                if self == ShowPoiModeEnum.allValues[i] {
                    
                    return i
                }
            }
            return -1
        }
    }
    
    // 查询指定位置的元素
    static func instance(index:Int) -> ShowPoiModeEnum? {
        
        if index >= 0 && index < ShowPoiModeEnum.allValues.count {
            
            return ShowPoiModeEnum.allValues[index]
        }
        return nil
    }
}