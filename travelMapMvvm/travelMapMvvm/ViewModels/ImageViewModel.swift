//
//  ImageViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/8/28.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ImageViewModel: NSObject {
   
    dynamic var image:UIImage = UIImage()
    
    /**
     * 下载图片(正常GCD)
     *
     * @param url 图片地址
     * @callback 回调
     *
     * @return
     */
    class func downloadImageWithUrl(url: NSURL, callback: NetRequestCallBackForDownloadImage) {
        
        ImageDataSource.shareInstance().downloadImageWithUrl(url, callback: callback)
    }
    
    /**
     * 下载图片(使用ReactiveCocoa)
     *
     * @param url 图片地址
     *
     * @return RACSingal 信号
     */
    func downloadImageWithUrl(url: NSURL) -> RACSignal {
        
        return ImageDataSource.shareInstance().downloadImageWithUrl(url)
    }
}
