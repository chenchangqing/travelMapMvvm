//
//  POIMapViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/11.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveViewModel
import ReactiveCocoa

class POIMapViewModel: RVMViewModel {
   
    dynamic var poiList = [POIModel]()  // POI列表
    
    override init() {
        super.init()
    }
}
