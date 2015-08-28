//
//  ImageDataSource.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa
import AFNetworking

class ImageDataSource: ImageDataSourceProtocol {
    
    // MARK: - 单例
    
    class func shareInstance()->ImageDataSourceProtocol{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:ImageDataSource? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance=ImageDataSource()
        })
        return YRSingleton.instance!
    }
    
    func downloadImageWithUrl(url: NSURL) -> RACSignal {
        
        let scheduler = RACScheduler(priority: RACSchedulerPriorityBackground)
        let signal = RACSignal.createSignal({
            (subscriber: RACSubscriber!) -> RACDisposable! in
            
            let session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: url)
            
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if (error == nil) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        let image = UIImage(data: data)
                        UIImageView.sharedImageCache().cacheImage(image, forRequest: request)
                        subscriber.sendNext(ResultModel(success: true, msg: msgImageDownloadSuccess, data: image))
                        subscriber.sendCompleted()
                        AFNetworkActivityIndicatorManager.sharedManager().decrementActivityCount()
                    })
                } else {
                    
                    let error = NSError.instance("queryModelList", errorStr: error.description)
                    subscriber.sendError(error)
                    AFNetworkActivityIndicatorManager.sharedManager().decrementActivityCount()
                }
            })
            task.resume()
            AFNetworkActivityIndicatorManager.sharedManager().incrementActivityCount()
            
            return nil
        })
        return signal.subscribeOn(scheduler)
    }
}
