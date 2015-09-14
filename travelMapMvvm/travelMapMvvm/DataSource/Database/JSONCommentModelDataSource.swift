//
//  JSONCommentModelDataSource.swift
//  travelMapMvvm
//
//  Created by green on 15/9/14.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa

class JSONCommentModelDataSource: CommentModelDataSourceProtocol {
    
    // MARK: - 单例
    
    class func shareInstance()->CommentModelDataSourceProtocol{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:JSONCommentModelDataSource? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance=JSONCommentModelDataSource()
        })
        return YRSingleton.instance!
    }
    
    func queryPOICommentList(poiId: String, rows: Int, startId: String?) -> RACSignal {
        
        return  RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 1)), dispatch_get_main_queue(), { () -> Void in
                
                let resultDic = ReadJsonClass.readJsonData("queryPOICommentList")
                
                if resultDic.error == nil {
                    
                    if let data: AnyObject=resultDic.data {
                        
                        var list = [CommentModel]()
                        
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

