//
//  POITypeViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/16.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveViewModel

class POITypeViewModel: RVMViewModel {
    
    // MARK: - POIContainer View Model
    
    var poiContainerViewModel: POIContainerViewModel!
    
    // MARK: - Data
    
    var showPoiMode: ShowPoiModeEnum                    // 地图/列表
    
    // MARK: - Init
    
    init(poiContainerViewModel: POIContainerViewModel,showPoiMode:ShowPoiModeEnum) {
        
        self.poiContainerViewModel = poiContainerViewModel
        self.showPoiMode = showPoiMode
        
        super.init()
    }
}
