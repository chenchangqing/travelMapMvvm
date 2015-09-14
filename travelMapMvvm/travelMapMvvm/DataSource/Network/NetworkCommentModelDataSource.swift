//
//  NetworkCommentModelDataSource.swift
//  travelMapMvvm
//
//  Created by green on 15/9/14.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa

class NetworkCommentModelDataSource: CommentModelDataSourceProtocol {
    
    // MARK: - 单例
    
    class func shareInstance()->CommentModelDataSourceProtocol{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:NetworkCommentModelDataSource? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance=NetworkCommentModelDataSource()
        })
        return YRSingleton.instance!
    }
    
    func queryPOICommentList(poiId: String, rows: Int, startId: String?) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            // 参数
            let startId = startId == nil ? "" : startId!
            let parameters:[String : AnyObject] = [
                
                "poiId"             : poiId,
                "rows"              : rows,
                "startId"           : startId
            ]
            
            NetRequestClass.netRequestGETWithRequestURL({ (error, data) -> Void in
                
                if error == nil {
                    
                    var list = [CommentModel]()
                    
                    list <-- data!
                    
                    subscriber.sendNext(list)
                    subscriber.sendCompleted()
                } else {
                    
                    subscriber.sendError(error)
                    
                }
                }, requestURlString: "URL", parameters: parameters)
            
            return nil
        })
    }
}