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
    
    func queryModelList(params: QueryModelListParams01) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
                
            NetRequestClass.netRequestGETWithRequestURL({ (error, data) -> Void in
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 2)), dispatch_get_main_queue(), { () -> Void in
                    
                    if error == nil {
                        
                        subscriber.sendNext(data!)
                        subscriber.sendCompleted()
                    } else {
                        
                        subscriber.sendError(error)
                        
                    }
                })
            }, requestURlString: "URL")
            
            return nil
        })
    }
}
