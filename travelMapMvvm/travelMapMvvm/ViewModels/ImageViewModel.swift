//
//  ImageViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/8/31.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa

class ImageViewModel: NSObject {
   
    var urlString : String?         // 图片路径
    {
        didSet {
            
            self.setValue(isValidPicUrl(), forKey: "url")
        }
    }
    
    // 被观察的图片，一旦变更及时更新视图
    var url  : NSURL?
    var image:UIImage = UIImage()
    
    private var imageDataSourceProtocol = ImageDataSource.shareInstance()
    var downloadImageCommand : RACCommand!

    /**
     * 初始化 
     */
    init(urlString:String?,defaultImage:UIImage = UIImage()) {
        
        super.init()
        
        self.urlString  = urlString
        self.image      = defaultImage
        
        // 是否可以执行下载图片的命令
        let commandEnabledSignal = RACObserve(self, "url").map { (any:AnyObject!) -> AnyObject! in
            
            if any != nil {
                return true
            } else {
                return false
            }
        }.distinctUntilChanged()
        
        // 初始化下载图片命令
        downloadImageCommand = RACCommand(enabled: commandEnabledSignal, signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            // 获得下载信号
            let signal = self.imageDataSourceProtocol.downloadImageWithUrl(self.url!)
            
            // 获得图片
            signal.subscribeNextAs({ (image:UIImage) -> () in
                
                self.setValue(image, forKey: "image")
            })
            
            // 下载图片错误处理
            signal.subscribeError({ (error:NSError!) -> Void in
                
                println(error.localizedDescription)
            })
            return signal
        })
        
        // 初始化图片url
        self.setValue(isValidPicUrl(), forKey: "url")
    }
    
    /**
     * 图片是否有效
     */
    private func isValidPicUrl() -> NSURL? {
        
        if let picUrl=urlString {
            
            if let url=NSURL(string: picUrl) {
                
                return url
            }
        }
        return nil
    }
}
