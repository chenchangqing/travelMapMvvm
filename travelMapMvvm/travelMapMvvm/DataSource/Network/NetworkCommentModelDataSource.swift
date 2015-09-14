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
    
    private let userModelDataSourceProtocol = JSONUserModelDataSource.shareInstance()
    
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
    
    func addPOIComment(content: String, level: POILevelEnum, poiId: String) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            let commentModel = CommentModel()
            commentModel.commentId = "12345"
            commentModel.commentTime = "2015-08-08 00:00:00"
            commentModel.content = content
            commentModel.level = level
            
            if let userModel = self.userModelDataSourceProtocol.queryUser() {
                
                commentModel.author = userModel.userName
                commentModel.authorPicUrl = userModel.userPicUrl
            }
            
            subscriber.sendNext(commentModel)
            subscriber.sendCompleted()
            
            return nil
        })
    }
}