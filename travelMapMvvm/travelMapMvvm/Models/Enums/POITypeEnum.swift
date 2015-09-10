//
//  POITypeEnum.swift
//  travelMap
//
//  Created by green on 15/8/24.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import Foundation

enum POITypeEnum: String {
    
    case Scenic     = "景点"
    case Food       = "餐饮"
    case Shopping   = "购物"
    case Hotel      = "酒店"
    case Activity   = "活动"
    
    static let allValues = [Scenic,Food,Shopping,Hotel,Activity]
    
    // 位置
    var index : Int {
        
        get {
            
            for var i = 0; i < POITypeEnum.allValues.count; i++ {
                
                if self == POITypeEnum.allValues[i] {
                    
                    return i
                }
            }
            return -1
        }
    }
    
    // 查询指定位置的元素
    static func instance(index:Int) -> POITypeEnum? {
        
        if index >= 0 && index < POITypeEnum.allValues.count {
            
            return POITypeEnum.allValues[index]
        }
        return nil
    }
}