//
//  POIModelDataSourceProtocol.swift
//  travelMapMvvm
//
//  Created by green on 15/9/11.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa
import Foundation

protocol POIModelDataSourceProtocol {
    
    /**
     * 查询POI列表
     * 
     * @strategyId 攻略ID
     * @rows       行数
     * @startPOIId 从这ID开始查询
     *
     * @return  POI列表信号
     */
    func queryPOIList(strategyId:String, rows:Int, startId:String?) -> RACSignal
}