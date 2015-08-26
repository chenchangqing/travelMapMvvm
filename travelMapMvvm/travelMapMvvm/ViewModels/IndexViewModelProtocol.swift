//
//  IndexViewModelProtocol.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

protocol IndexViewModelProtocol {
    
    // 被观察的数据
    var indexViewObservedModel : IndexViewObservedModel { get set }
    
    /**
     * 下拉刷新
     */
    func refreshStrategyList()
    
    /**
     * 上拉加载更多
     */
    func loadmoreStrategyList()
    
}