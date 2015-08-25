//
//  StrategyModelDataSourceProtocol.swift
//  travelMapMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation

/**
 * 攻略数据操作
 */
protocol StrategyModelDataSourceProtocol {
   
    /**
     * 首页查询攻略
    */
    func queryModelList(params: QueryModelListParams01) -> [StrategyModel]
}