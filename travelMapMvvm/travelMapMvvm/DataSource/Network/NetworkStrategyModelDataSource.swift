//
//  NetworkStrategyModelDataSource.swift
//  travelMapMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa

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
    
    func queryStrategyListBySystem(
        strategyThemeArray:[StrategyThemeEnum],strategyMonthArray:[MonthEnum],strategyTypeArray:[StrategyTypeEnum],order: StrategyOrderEnum,rowCount: Int,startId: String?) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            // 参数
            let startId = startId == nil ? "" : startId!
            let parameters:[String : AnyObject] = [
                
                "strategyThemeArray": StrategyThemeEnum.covertToString(strategyThemeArray),
                "strategyMonthArray": MonthEnum.covertToString(strategyMonthArray),
                "strategyTypeArray" : StrategyTypeEnum.covertToString(strategyTypeArray),
                "order"             : rowCount,
                "startId"           : startId
            ]
                
            NetRequestClass.netRequestGETWithRequestURL({ (error, data) -> Void in
                
                if error == nil {
                    
                    var strategyList = [StrategyModel]()
                    
                    strategyList <-- data!
                    
                    subscriber.sendNext(strategyList)
                    subscriber.sendCompleted()
                } else {
                    
                    subscriber.sendError(error)
                    
                }
            }, requestURlString: "URL", parameters: parameters)
            
            return nil
        })
    }
    
    func queryStrategyListByKeyword(keyword: String, order: StrategyOrderEnum, rowCount: Int, startId: String?) -> RACSignal {
        
        return RACSignal.empty()
    }
    
    func queryStrategyListByUserId(userId: String, order: StrategyOrderEnum, rowCount: Int, startId: String?) -> RACSignal {
        
        return RACSignal.empty()
    }
}
