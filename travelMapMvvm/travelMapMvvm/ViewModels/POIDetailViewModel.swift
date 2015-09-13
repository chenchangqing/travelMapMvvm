//
//  POIDetailViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/13.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa
import ReactiveViewModel

class POIDetailViewModel: RVMViewModel {
   
    // MARK: - POI IMAGE
    
    var poiImageViewModel = ImageViewModel(urlString: nil, defaultImage:UIImage(named: "defaultImage.jpg")!)
    
    // MARK: - POI Model
    
    dynamic var poiModel : POIModel!
    
    
    // MARK: - INIT
    
    init(poiModel:POIModel) {
        
        self.poiModel = poiModel
        
        super.init()
        
        RACObserve(self.poiModel, "poiPicUrl").ignore(nil).subscribeNext { (poiPicUrl:AnyObject?) -> () in
            
            self.poiImageViewModel.urlString = poiPicUrl as? String
            self.poiImageViewModel.downloadImageCommand.execute(nil)
        }
        
    }
}
