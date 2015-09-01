//
//  CacheStrategyModelDataSource.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa

class JSONStrategyModelDataSource: StrategyModelDataSourceProtocol {
    
    // MARK: - 单例
    
    class func shareInstance()->StrategyModelDataSourceProtocol{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:JSONStrategyModelDataSource? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance=JSONStrategyModelDataSource()
        })
        return YRSingleton.instance!
    }
    
    func queryStrategyList(params: QueryStrategyModelListParams01) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 1)), dispatch_get_main_queue(), { () -> Void in
                
                let resultDic = ReadJsonClass.readJsonData("queryStrategyList")
                
                if resultDic.error == nil {
                    
                    if let data: AnyObject=resultDic.data {
                        
                        var strategyList = [StrategyModel]()
                        
                        strategyList <-- data[kData]
                        
                        subscriber.sendNext(strategyList)
                        subscriber.sendCompleted()
                    } else {
                        
                        subscriber.sendError(NSError(
                            domain:kErrorDomain,
                            code: ErrorEnum.JSONError.errorCode,
                            userInfo: [NSLocalizedDescriptionKey:ErrorEnum.JSONError.rawValue]
                        ))
                    }
                } else {
                    
                    subscriber.sendError(resultDic.error!)
                }
            })
            
            return nil
        })
    }
}
