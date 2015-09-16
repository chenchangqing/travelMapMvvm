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
    
    // MARK: - 查询类型
    
    var queryType: QueryTypeEnum!
    
    // MARK: - Init
    
    init(queryType: QueryTypeEnum) {
        
        super.init()
        
        self.queryType = queryType
    }
}
