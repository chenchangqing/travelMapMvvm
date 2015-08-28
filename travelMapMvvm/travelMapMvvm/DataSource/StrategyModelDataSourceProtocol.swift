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
     * 查询攻略列表(callback)
     *
     * @param strategyThemes 攻略主题
     * @param strategyTypes 攻略类型
     * @param strategyMonths 攻略月份
     * @param strategyOrder 攻略排序
     * @param rows 查询行数
     * @param startStrategyId 从这个ID开始查询
     *
     * @return
     */
    func queryModelList(params: QueryModelListParams01,callback:NetReuqestCallBackForStrategyModelArray)
    
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
    func queryModelList(params: QueryModelListParams01) -> RACSignal
    
}