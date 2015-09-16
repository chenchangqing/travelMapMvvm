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
    var segmentedControlItems = POITypeEnum.allValues // 分段数据
    
    // MARK: - Init
    
    init(poiContainerViewModel: POIContainerViewModel) {
        
        super.init()
        
        self.poiContainerViewModel = poiContainerViewModel
    }
}
