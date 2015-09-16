//
//  QueryTypeEnum.swift
//  travelMapMvvm
//
//  Created by green on 15/9/16.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation

enum QueryTypeEnum: String {
    
    case POIListByCityId      = "城市POI"
    case POIListByKeyword     = "关键字POI"
    case POIListByUserId      = "已收藏POI"
    case POIListByStrategyId  = "攻略POI"
    case POIListByCenterPOIId = "周边POI"
    case StrategyListBySystem     = "系统推荐攻略"
    case StrategyListByKeyword    = "关键字攻略"
    case StrategyListByUserId     = "已收藏攻略"
    
    static let allValues = [POIListByCityId,POIListByKeyword,POIListByUserId,POIListByStrategyId,POIListByCenterPOIId,StrategyListBySystem,StrategyListByKeyword,StrategyListByUserId]
    
    // 位置
    var index : Int {
        
        get {
            
            for var i = 0; i < QueryTypeEnum.allValues.count; i++ {
                
                if self == QueryTypeEnum.allValues[i] {
                    
                    return i
                }
            }
            return -1
        }
    }
    
    // 查询指定位置的元素
    static func instance(index:Int) -> QueryTypeEnum? {
        
        if index >= 0 && index < QueryTypeEnum.allValues.count {
            
            return QueryTypeEnum.allValues[index]
        }
        return nil
    }
}