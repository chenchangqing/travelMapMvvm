//
//  DesViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/8/31.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa

class DesViewModel: NSObject {
    
    private var selectionViewDataSourceProtocol:SelectionViewDataSourceProtocol = SelectionViewDataSource.shareInstance()
    
    // 数据源
    var dataSource = DataSource(dataSource: OrderedDictionary<CJCollectionViewHeaderModel, [CJCollectionViewCellModel]>())
    var desSelectionDicSearch : RACCommand!
    private var cellWidth:CGFloat!
    
    init(cellWidth:CGFloat) {
        
        super.init()
        
        self.cellWidth = cellWidth
        // 初始化命令
        setupFilterSelectionDicSearch()
    }
    
    private func setupFilterSelectionDicSearch() {
        
        desSelectionDicSearch = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            let signal = self.selectionViewDataSourceProtocol.queryOrderDictionary(self.cellWidth)
            
            let scheduler = RACScheduler(priority: RACSchedulerPriorityBackground)
            return signal.subscribeOn(scheduler)
        })
        
        desSelectionDicSearch.executionSignals.switchToLatest().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNextAs { (dataSource:DataSource) -> () in
            
            self.setValue(dataSource, forKey: "dataSource")
        }
    }
}
