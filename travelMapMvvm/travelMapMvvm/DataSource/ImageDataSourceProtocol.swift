//
//  ImageDataSourceProtocol.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

/**
 * 图片处理操作
 */
protocol ImageDataSourceProtocol {
    
    /**
     * 下载图片
     * 
     * @param url 图片地址
     * @callback 回调
     *
     * @return
     */
    func downloadImageWithUrl(url: NSURL, callback:NetRequestCallBackForDownloadImage)
}