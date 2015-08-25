//
//  CJCollectionViewHeaderModelTypeEnum.swift
//  CJMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import Foundation


enum CJCollectionViewHeaderModelTypeEnum : String {
    
    case MultipleChoice = "多选"
    case SingleChoice   = "单选"
    case SingleClick    = "单击"
    
    static let allValues = [MultipleChoice,SingleChoice,SingleClick]
    
    // 位置
    var index : Int {
        
        get {
            
            for var i = 0; i < CJCollectionViewHeaderModelTypeEnum.allValues.count; i++ {
                
                if self == CJCollectionViewHeaderModelTypeEnum.allValues[i] {
                    
                    return i
                }
            }
            return -1
        }
    }
    
    // 查询指定位置的元素
    static func instance(index:Int) -> CJCollectionViewHeaderModelTypeEnum? {
        
        if index >= 0 && index < CJCollectionViewHeaderModelTypeEnum.allValues.count {
            
            return CJCollectionViewHeaderModelTypeEnum.allValues[index]
        }
        return nil
    }
}