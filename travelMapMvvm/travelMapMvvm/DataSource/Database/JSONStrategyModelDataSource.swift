//
//  CacheStrategyModelDataSource.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import JSONHelper
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
    
    // MARK: - implement
    
    func queryModelList(params: QueryModelListParams01, callback: NetReuqestCallBackForStrategyModelArray) {
        
        let resultDic = ReadJsonClass.readJsonData(kQueryStrategyList)
        
        let success = resultDic[kSuccess] as? Bool
        let msg     = resultDic[kMsg] as? String
        let data: AnyObject?    = resultDic[kData]
        
        if let success=success {
            
            var strategyList = [StrategyModel]()
            
            if let data: AnyObject=data {
                
                strategyList <-- data
                
                callback(success: success, msg: msg, data: strategyList)
            } else {
                
                callback(success: false, msg: msg, data: nil)
            }
        } else {
            
            callback(success: false, msg: msg, data: nil)
        }
    }
    
    
    func queryModelList(params: QueryModelListParams01) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            let resultDic = ReadJsonClass.readJsonData(kQueryStrategyList)
            
            let success = resultDic[kSuccess] as? Bool
            let msg     = resultDic[kMsg] as? String
            let data: AnyObject?    = resultDic[kData]
            
            if let success=success {
                
                var strategyList = [StrategyModel]()
                
                if let data: AnyObject=data {
                    
                    strategyList <-- data
                    
                    subscriber.sendNext(ResultModel(success: true, msg: msg, data: strategyList))
                } else {
                    
                    subscriber.sendNext(ResultModel(success: false, msg: msg, data: nil))
                }
            } else {
                
                subscriber.sendNext(ResultModel(success: false, msg: msg, data: nil))
            }
            subscriber.sendCompleted()
            
            return nil
        })
    }
}
