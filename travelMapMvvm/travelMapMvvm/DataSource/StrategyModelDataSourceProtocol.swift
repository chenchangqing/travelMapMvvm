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
     * 系统推荐攻略
     *
     * @param strategyThemes 攻略主题
     * @param strategyTypes 攻略类型
     * @param strategyMonths 攻略月份
     * @param strategyOrder 攻略排序
     * @param rows 查询行数
     * @param startId 从这个ID开始查询
     *
     * @return RACSignal
     */
    func queryStrategyListBySystem(strategyThemeArray:[StrategyThemeEnum],strategyMonthArray:[MonthEnum],strategyTypeArray:[StrategyTypeEnum],order: StrategyOrderEnum,rowCount: Int,startId: String?) -> RACSignal
    
    /**
     * 关键字攻略
     *
     * @param keyword 关键字
     * @param strategyOrder 攻略排序
     * @param rows 查询行数
     * @param startId 从这个ID开始查询
     * 
     * @return RACSignal
     */
    func queryStrategyListByKeyword(keyword:String,order: StrategyOrderEnum,rowCount: Int,startId: String?) -> RACSignal
    
    
    /**
     * 已收藏攻略
     *
     * @param keyword 关键字
     * @param strategyOrder 攻略排序
     * @param rows 查询行数
     * @param startId 从这个ID开始查询
     *
     * @return RACSignal
     */
    func queryStrategyListByUserId(userId:String,order: StrategyOrderEnum,rowCount: Int,startId: String?) -> RACSignal
}