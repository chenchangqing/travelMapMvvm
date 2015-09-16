//
//  POIModelDataSource.swift
//  travelMapMvvm
//
//  Created by green on 15/9/11.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa

class JSONPOIModelDataSource: POIModelDataSourceProtocol {

    // MARK: - 单例
    
    class func shareInstance()->POIModelDataSourceProtocol{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:JSONPOIModelDataSource? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance=JSONPOIModelDataSource()
        })
        return YRSingleton.instance!
    }
    
    func queryPOIListByCenterPOIId(centerPoiId: String, poiType: POITypeEnum?, rows: Int, startId: String?) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 1)), dispatch_get_main_queue(), { () -> Void in
                
                let resultDic = ReadJsonClass.readJsonData("queryPOIList")
                
                if resultDic.error == nil {
                    
                    if let data: AnyObject=resultDic.data {
                        
                        var list = [POIModel]()
                        
                        list <-- data[kData]
                        
                        subscriber.sendNext(list)
                        subscriber.sendCompleted()
                    } else {
                        
                        subscriber.sendError(ErrorEnum.JSONError.error)
                        
                    }
                } else {
                    
                    subscriber.sendError(resultDic.error!)
                }
            })
            
            return nil
        })
    }
    
    func queryPOIListByCityId(cityId: String, poiType: POITypeEnum?, rows: Int, startId: String?) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 1)), dispatch_get_main_queue(), { () -> Void in
                
                let resultDic = ReadJsonClass.readJsonData("queryPOIList")
                
                if resultDic.error == nil {
                    
                    if let data: AnyObject=resultDic.data {
                        
                        var list = [POIModel]()
                        
                        list <-- data[kData]
                        
                        subscriber.sendNext(list)
                        subscriber.sendCompleted()
                    } else {
                        
                        subscriber.sendError(ErrorEnum.JSONError.error)
                        
                    }
                } else {
                    
                    subscriber.sendError(resultDic.error!)
                }
            })
            
            return nil
        })
    }
    
    func queryPOIListByKeyword(keyword: String, poiType: POITypeEnum?, rows: Int, startId: String?) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 1)), dispatch_get_main_queue(), { () -> Void in
                
                let resultDic = ReadJsonClass.readJsonData("queryPOIList")
                
                if resultDic.error == nil {
                    
                    if let data: AnyObject=resultDic.data {
                        
                        var list = [POIModel]()
                        
                        list <-- data[kData]
                        
                        subscriber.sendNext(list)
                        subscriber.sendCompleted()
                    } else {
                        
                        subscriber.sendError(ErrorEnum.JSONError.error)
                        
                    }
                } else {
                    
                    subscriber.sendError(resultDic.error!)
                }
            })
            
            return nil
        })
    }
    
    func queryPOIListByStrategyId(strategyId: String, poiType: POITypeEnum?, rows: Int, startId: String?) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 1)), dispatch_get_main_queue(), { () -> Void in
                
                let resultDic = ReadJsonClass.readJsonData("queryPOIList")
                
                if resultDic.error == nil {
                    
                    if let data: AnyObject=resultDic.data {
                        
                        var list = [POIModel]()
                        
                        list <-- data[kData]
                        
                        subscriber.sendNext(list)
                        subscriber.sendCompleted()
                    } else {
                        
                        subscriber.sendError(ErrorEnum.JSONError.error)
                        
                    }
                } else {
                    
                    subscriber.sendError(resultDic.error!)
                }
            })
            
            return nil
        })
    }
    
    func queryPOIListByUserId(userId: String, poiType: POITypeEnum?, rows: Int, startId: String?) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 1)), dispatch_get_main_queue(), { () -> Void in
                
                let resultDic = ReadJsonClass.readJsonData("queryPOIList")
                
                if resultDic.error == nil {
                    
                    if let data: AnyObject=resultDic.data {
                        
                        var list = [POIModel]()
                        
                        list <-- data[kData]
                        
                        subscriber.sendNext(list)
                        subscriber.sendCompleted()
                    } else {
                        
                        subscriber.sendError(ErrorEnum.JSONError.error)
                        
                    }
                } else {
                    
                    subscriber.sendError(resultDic.error!)
                }
            })
            
            return nil
        })
    }
}