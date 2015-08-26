//
//  StrategyCellModelProtocol.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

protocol StrategyCellModelProtocol {
    
    // 被观察的对象
    var strategyCellObservedModel : StrategyCellObservedModel { get set }
    
    /**
     * 下载攻略图片
     */
    func downloadStrategyImage(url:NSURL)
}
