//
//  QueryModelListPageParams.swift
//  travelMapMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation

/**
* 首页查询攻略参数结构体
*/
struct QueryModelListPageParams{
    
    var strategyThemeArray:[StrategyThemeEnum] = StrategyThemeEnum.allValues
    var strategyMonthArray:[MonthEnum] = MonthEnum.allValues
    var strategyTypeArray:[StrategyTypeEnum] = StrategyTypeEnum.allValues
    var order: StrategyOrderEnum = StrategyOrderEnum.Default
    var rows: Int = 5
    var startId: String?
}