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
     * 
     * @param 攻略主题数组
     * @param 旅游月份数组
     * @param 攻略类型数组
     * @param 攻略排序
     * @param 行数
     * @param 攻略ID(查询这个ID以后的数据)
     *
     * @return
     */
    func queryModelList(params: QueryModelListParams01) -> [StrategyModel]
}