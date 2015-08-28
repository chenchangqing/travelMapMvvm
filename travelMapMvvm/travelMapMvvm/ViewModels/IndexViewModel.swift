//
//  IndexViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa

class IndexViewModel: NSObject {
    
    private var strategyModelDataSourceProtocol = JSONStrategyModelDataSource.shareInstance()
    
    dynamic var strategyList = [StrategyModel]()
    var executeSearch : RACCommand!
    
    override init() {
        
        super.init()
        
        executeSearch = RACCommand() {
            (any:AnyObject!) -> RACSignal in
        
            let singal = self.strategyModelDataSourceProtocol.queryModelList(QueryModelListParams01())
            
            singal.subscribeNextAs({ (result:ResultModel!) -> Void in
                
                if let strategyList = result.data as? [StrategyModel] {
                    
                    self.strategyList = strategyList
                }
            })
            
            return singal
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 3)), dispatch_get_main_queue()) { () -> Void in
            
            executeSearch.execute(nil)
        }
    }
    
}
