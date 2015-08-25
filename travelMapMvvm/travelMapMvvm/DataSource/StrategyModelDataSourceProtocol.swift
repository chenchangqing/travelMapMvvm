//
//  StrategyModelDataSourceProtocol.swift
//  travelMapMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation

/**
 * 首页查询攻略参数结构体
 */
struct QueryModelListForIndexPageParams{
    
    var strategyThemeArray:[StrategyThemeEnum] = StrategyThemeEnum.allValues
    var strategyMonthArray:[MonthEnum] = MonthEnum.allValues
    var strategyTypeArray:[StrategyTypeEnum] = StrategyTypeEnum.allValues
    var order: StrategyOrderEnum = StrategyOrderEnum.Default
    var rows: Int = 5
    var startId: String?
}

/**
 * 攻略数据操作
 */
protocol StrategyModelDataSourceProtocol {
   
    /**
     * 首页查询攻略
     */
    func queryModelListForIndexPage(params: QueryModelListForIndexPageParams) -> [StrategyModel]
}