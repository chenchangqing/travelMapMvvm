//
//  IndexViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa

class IndexViewModel: NSObject {
    
//    private var strategyModelDataSourceProtocol = NetworkStrategyModelDataSource.shareInstance()
    private var strategyModelDataSourceProtocol = JSONStrategyModelDataSource.shareInstance()
    
    // 数据源（一直处于被观察状态）
    dynamic var strategyList = [StrategyModel]()
    
    // 查询命令
    var executeSearch : RACCommand!
    
    override init() {
        
        super.init()
        
        setupExecuteSearch()
    }
    
    // MARK : - setup
    
    /**
     * 初始化查询命令
     */
    private func setupExecuteSearch() {
        
        executeSearch = RACCommand() { (any:AnyObject!) -> RACSignal in
            
            // 查询
            let singal = self.strategyModelDataSourceProtocol.queryModelList(QueryModelListParams01())
            
            // 错误处理
            singal.subscribeError({ (error:NSError!) -> Void in
                
                println(error.domain)
                self.strategyList = [StrategyModel]()
            })
            
            // 重置数据源
            singal.subscribeNextAs({ (result:ResultModel!) -> Void in
                
                if let strategyList = result.data as? [StrategyModel] {
                    
                    self.strategyList = strategyList
                }
            })
            
            return singal
        }
    }
    
}
