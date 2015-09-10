//
//  StrategyModelDataSourceProtocol.swift
//  travelMapMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa

/**
 * 攻略数据操作
 */
protocol StrategyModelDataSourceProtocol {
    
    /**
     * 查询攻略列表(singal)
     *
     * @param strategyThemes 攻略主题
     * @param strategyTypes 攻略类型
     * @param strategyMonths 攻略月份
     * @param strategyOrder 攻略排序
     * @param rows 查询行数
     * @param startStrategyId 从这个ID开始查询
     *
     * @return RACSignal
     */
    func queryStrategyList(params: QueryStrategyModelListParams01) -> RACSignal
    
    /**
     * 查询攻略列表
     * 
     * @param strategyId 攻略ID
     *
     * @return RACSignal 攻略列表
     */
    func queryStrategyList(strategyId: String) -> RACSignal
    
}