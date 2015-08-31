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
            
            let request = NSMutableURLRequest(URL: url)
            
            if let image = UIImageView.sharedImageCache().cachedImageForRequest(request) {
                
                // 内存加载
                subscriber.sendNext(image)
                subscriber.sendCompleted()
            } else {
                
                // 网络下载
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in

                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        AFNetworkActivityIndicatorManager.sharedManager().decrementActivityCount()
                    })
                    let downloadImageError = NSError(
                        domain: kErrorDomain,
                        code: ErrorEnum.ImageDownloadError.errorCode,
                        userInfo: [NSLocalizedDescriptionKey:ErrorEnum.ImageDownloadError.rawValue + "(" + url.description + ")"])
                    
                    if (error == nil) {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            let image = UIImage(data: data)
                            
                            if let image=image {
                                
                                UIImageView.sharedImageCache().cacheImage(image, forRequest: request)
                                subscriber.sendNext(image)
                                subscriber.sendCompleted()
                            } else {
                                
                                subscriber.sendError(downloadImageError)
                            }
                        })
                    } else {
                        
                        subscriber.sendError(downloadImageError)
                    }
                })
                task.resume()
                AFNetworkActivityIndicatorManager.sharedManager().incrementActivityCount()
            }
            
            return nil
        })
        return signal
    }
}
