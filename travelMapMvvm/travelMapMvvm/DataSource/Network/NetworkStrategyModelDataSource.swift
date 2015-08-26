//
//  NetworkStrategyModelDataSource.swift
//  travelMapMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

class NetworkStrategyModelDataSource: StrategyModelDataSourceProtocol {
    
    // MARK: - 单例
    
    class func shareInstance()->StrategyModelDataSourceProtocol{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:NetworkStrategyModelDataSource? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance=NetworkStrategyModelDataSource()
        })
        return YRSingleton.instance!
    }
   
    func queryModelList(params: QueryModelListParams01, callback: NetReuqestCallBackForStrategyModelArray) {
        
    }
}
