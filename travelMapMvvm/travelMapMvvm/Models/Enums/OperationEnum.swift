//
//  OperationEnum.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//


enum OperationEnum : String {
    
    case DownPullRefresh = "上拉刷新"
    case UpPullLoadmore  = "上拉加载更多"
    
    static let allValues = [DownPullRefresh,UpPullLoadmore]
    
    // 位置
    var index : Int {
        
        get {
            
            for var i = 0; i < OperationEnum.allValues.count; i++ {
                
                if self == OperationEnum.allValues[i] {
                    
                    return i
                }
            }
            return -1
        }
    }
    
    // 查询指定位置的元素
    static func instance(index:Int) -> OperationEnum? {
        
        if index >= 0 && index < OperationEnum.allValues.count {
            
            return OperationEnum.allValues[index]
        }
        return nil
    }
}