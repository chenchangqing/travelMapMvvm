//
//  ImageDataSourceProtocol.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa

/**
 * 图片处理操作
 */
protocol ImageDataSourceProtocol {
    
    /**
     * 下载图片(正常GCD)
     * 
     * @param url 图片地址
     * @callback 回调
     *
     * @return
     */
    func downloadImageWithUrl(url: NSURL, callback:NetRequestCallBackForDownloadImage)
    
    /**
     * 下载图片(使用ReactiveCocoa)
     *
     * @param url 图片地址
     *
     * @return RACSingal 信号
     */
    func downloadImageWithUrl(url: NSURL) -> RACSignal
}