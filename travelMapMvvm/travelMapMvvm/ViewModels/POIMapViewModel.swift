//
//  POIMapViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/11.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveViewModel

class POIMapViewModel: RVMViewModel {
   
    dynamic var poiList:[POIModel]!
    
    init(poiList:[POIModel]) {
        super.init()
        
        self.poiList = poiList
    }
}
