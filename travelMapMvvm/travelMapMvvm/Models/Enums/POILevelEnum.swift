//
//  POILevelEnum.swift
//  travelMap
//
//  Created by green on 15/8/24.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import Foundation

enum POILevelEnum: String {
    
    case One    = "一个星"
    case Two    = "二个星"
    case Three  = "三个星"
    case Four   = "四个星"
    case Five   = "五个星"
    
    static let allValues = [One,Two,Three,Four,Five]
    
    // 位置
    var index : Int {
        
        get {
            
            for var i = 0; i < POILevelEnum.allValues.count; i++ {
                
                if self == POILevelEnum.allValues[i] {
                    
                    return i
                }
            }
            return -1
        }
    }
    
    // 查询指定位置的元素
    static func instance(index:Int) -> POILevelEnum? {
        
        if index >= 0 && index < POILevelEnum.allValues.count {
            
            return POILevelEnum.allValues[index]
        }
        return nil
    }
}