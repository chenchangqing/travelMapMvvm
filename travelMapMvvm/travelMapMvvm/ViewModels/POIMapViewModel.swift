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
   
    dynamic var poiList = [POIModel]()
    
    override init() {
        super.init()
        
        RACObserve(self, "poiList").skip(1).subscribeNext { (any:AnyObject!) -> Void in
            
            println(any)
        }
    }
}
