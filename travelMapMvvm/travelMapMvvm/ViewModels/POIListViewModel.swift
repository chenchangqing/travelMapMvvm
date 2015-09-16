//
//  POIListViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/16.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveViewModel

class POIListViewModel: RVMViewModel {
    
    // MARK: - 提示信息
    
    dynamic var failureMsg  : String = ""   // 操作失败提示
    dynamic var successMsg  : String = ""   // 操作失败提示
    
    // MARK: - POI列表
    
    dynamic var poiList = [POIModel]()
    
    // MARK: - Commands
    
    var updatingLocationPlacemarkCommand: RACCommand!
    var refreshCommand: RACCommand!
    var loadmoreCommand: RACCommand!
    
    // MARK: - Init
    
    init(poiList:[POIModel],refreshCommand:RACCommand,loadmoreCommand: RACCommand) {
        
        super.init()
        
        self.poiList = poiList
        self.refreshCommand = refreshCommand
        self.loadmoreCommand = loadmoreCommand
    }
}