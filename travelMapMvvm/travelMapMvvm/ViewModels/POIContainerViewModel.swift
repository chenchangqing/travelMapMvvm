//
//  POIContainerViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/16.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveViewModel

class POIContainerViewModel: RVMViewModel {
    
    // MARK: - 查询参数元组
    
    var paramTuple: (queryType:QueryTypeEnum,param:String)
    
    // MARK: - Init
    
    init(paramTuple: (queryType:QueryTypeEnum,param:String)) {
        
        self.paramTuple = paramTuple
        
        super.init()
    }
}
