//
//  DownloadImageBusiness.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

class DownloadImageBusiness: AbstractBusinessProtocol {
    
    private var imageDataSourceProtocol : ImageDataSourceProtocol = ImageDataSource.shareInstance()
    
    // MARK: - implement
    
    var title : String {
        
        get {
            
            return "下载图片"
        }
    }
    
    var isValid : Bool {
        
        get {
            
            return true
        }
    }
    
    var businessModel = BusinessModel()
    
    func execute() {
        
        // 开始下载
        imageDataSourceProtocol.downloadImageWithUrl(url, callback: { (success, msg, data) -> Void in
            
            self.businessModel.setValue(success, forKey: kSuccess)
            self.businessModel.setValue(msg, forKey: kMsg)
            self.businessModel.setValue(data, forKey: kData)
        })
    }
    
    // MARK: -
    
    private var url : NSURL!
    
    // MARK: - init
    
    init(url:NSURL) {
        
        self.url = url
    }
}
