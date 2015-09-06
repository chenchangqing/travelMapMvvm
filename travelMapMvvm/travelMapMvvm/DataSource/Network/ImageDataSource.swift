//
//  ImageDataSource.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa
import AFNetworking
import AFImageDownloader

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
    
    func downloadImageWithUrl(url: NSURL,isNeedCompress:Bool) -> RACSignal {
        
        let request = NSMutableURLRequest(URL: url)
        
        let downloadImageError = NSError(
            domain: kErrorDomain,
            code: ErrorEnum.ImageDownloadError.errorCode,
            userInfo: [NSLocalizedDescriptionKey:ErrorEnum.ImageDownloadError.rawValue + "(" + url.description + ")"])
        
        let signal = RACSignal.createSignal({
            (subscriber: RACSubscriber!) -> RACDisposable! in
            
            // 网络下载
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    AFNetworkActivityIndicatorManager.sharedManager().decrementActivityCount()
                })
                
                if (error == nil) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        if let image = UIImage(data: data) {
                            subscriber.sendNext(data)
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
            
            return RACDisposable(block: { () -> Void in
                
                task.cancel()
            })
        })
        
        // 压缩
        if isNeedCompress {
            
            return signal.flattenMap { (any:AnyObject!) -> RACStream! in
                
                return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
                    
                    let data = (any as! NSData)
                    if let image = UIImage(data: data) {
                        
                        data.af_decompressedImageFromJPEGDataWithCallback { (image:UIImage!) -> Void in
                            
                            UIImageView.sharedImageCache().cacheImage(image, forRequest: request)
                            subscriber.sendNext(image)
                            subscriber.sendCompleted()
                        }
                    } else {
                        
                        subscriber.sendError(downloadImageError)
                    }
                    return nil
                })
            }
        } else {
            
            return signal.map({ (any:AnyObject!) -> AnyObject! in
                
                let image = UIImage(data: any as! NSData)
                UIImageView.sharedImageCache().cacheImage(image, forRequest: request)
                
                return image
            })
        }
        
    }
}
