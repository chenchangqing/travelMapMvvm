//
//  FilterViewModjel.swift
//  travelMapMvvm
//
//  Created by green on 15/8/31.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa

class FilterViewModel: NSObject {
   
    private var selectionViewDataSourceProtocol:SelectionViewDataSourceProtocol = SelectionViewDataSource.shareInstance()
    
    // 被观察数据源
    var dataSource = DataSource(dataSource: OrderedDictionary<CJCollectionViewHeaderModel, [CJCollectionViewCellModel]>())
    var filterSelectionDicSearch : RACCommand!
    
    override init() {
        
        super.init()
        
        // 初始化命令
        setupFilterSelectionDicSearch()
    }
    
    private func setupFilterSelectionDicSearch() {
        
        filterSelectionDicSearch = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            let signal = self.selectionViewDataSourceProtocol.queryFilterDictionary()
            
            let scheduler = RACScheduler(priority: RACSchedulerPriorityBackground)
            return signal.subscribeOn(scheduler)
        })
        
        filterSelectionDicSearch.executionSignals.switchToLatest().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNextAs { (dataSource:DataSource) -> () in
            
            self.setValue(dataSource, forKey: "dataSource")
        }
    }
}
