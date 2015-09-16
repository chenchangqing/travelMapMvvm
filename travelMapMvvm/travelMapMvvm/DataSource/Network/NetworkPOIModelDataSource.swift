//
//  NetworkPOIModelDataSource.swift
//  travelMapMvvm
//
//  Created by green on 15/9/11.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa

class NetworkPOIModelDataSource: POIModelDataSourceProtocol {
    
    // MARK: - 单例
    
    class func shareInstance()->POIModelDataSourceProtocol{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:NetworkPOIModelDataSource? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance=NetworkPOIModelDataSource()
        })
        return YRSingleton.instance!
    }
    
//    func queryPOIList(strategyId: String, rows: Int, startId: String?) -> RACSignal {
//        
//        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
//            
//            // 参数
//            let startId = startId == nil ? "" : startId!
//            let parameters:[String : AnyObject] = [
//                
//                "strategyId"        : strategyId,
//                "rows"              : rows,
//                "startId"           : startId
//            ]
//            
//            NetRequestClass.netRequestGETWithRequestURL({ (error, data) -> Void in
//                
//                if error == nil {
//                    
//                    var list = [POIModel]()
//                    
//                    list <-- data!
//                    
//                    subscriber.sendNext(list)
//                    subscriber.sendCompleted()
//                } else {
//                    
//                    subscriber.sendError(error)
//                    
//                }
//                }, requestURlString: "URL", parameters: parameters)
//            
//            return nil
//        })
//    }
    
    func queryPOIListByCenterPOIId(centerPoiId: String, poiType: POITypeEnum?, rows: Int, startId: String?) -> RACSignal {
        
        return RACSignal.empty()
    }
    
    func queryPOIListByCityId(cityId: String, poiType: POITypeEnum?, rows: Int, startId: String?) -> RACSignal {
        
        return RACSignal.empty()
    }
    
    func queryPOIListByKeyword(keyword: String, poiType: POITypeEnum?, rows: Int, startId: String?) -> RACSignal {
        
        return RACSignal.empty()
    }
    
    func queryPOIListByStrategyId(strategyId: String, poiType: POITypeEnum?, rows: Int, startId: String?) -> RACSignal {
        
        return RACSignal.empty()
    }
    
    func queryPOIListByUserId(userId: String, poiType: POITypeEnum?, rows: Int, startId: String?) -> RACSignal {
        
        return RACSignal.empty()
    }
}
