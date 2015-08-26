//
//  StrategyCellModel.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

class StrategyCellModel: StrategyCellModelProtocol {
    
    private var imageDataSourceProtocol = ImageDataSource.shareInstance()
    
    // MARK: - Implement
    
    var strategyCellObservedModel = StrategyCellObservedModel()
    
    func downloadStrategyImage(url:NSURL) {
        
        imageDataSourceProtocol.downloadImageWithUrl(url, callback: { (success, msg, data) -> Void in
            
            if let data=data {
                
                self.strategyCellObservedModel.image = data
            }
        })
    }
}
