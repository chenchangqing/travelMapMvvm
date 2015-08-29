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
    
    // 下拉刷新操作
    var refreshSearch : RACCommand!
    
    // 上拉加载更多操作
    var loadmoreSearch : RACCommand!
    
    // 错误信息
    var errorMsg: String = ""
    
    override init() {
        
        super.init()
        
        // 初始化
        setupRefreshSearch()
        setupLoadmoreSearch()
    }
    
    // MARK : - setup
    
    /**
     * 初始化下拉刷新
     */
    private func setupRefreshSearch() {
        
        refreshSearch = RACCommand() { (any:AnyObject!) -> RACSignal in
            
            // 查询
            let singal = self.strategyModelDataSourceProtocol.queryModelList(QueryModelListParams01())
            
            // 错误处理
            singal.subscribeError({ (error:NSError!) -> Void in
                
                self.setValue(error.localizedDescription, forKey: "errorMsg")
                self.setValue([StrategyModel](), forKey: "strategyList")
            })
            
            // 重置数据源
            singal.subscribeNextAs({ (strategyList:[StrategyModel]!) -> Void in
                
                self.setValue(strategyList, forKey: "strategyList")
            })
            
            return singal
        }
    }
    
    /**
    * 初始化上拉加载
    */
    private func setupLoadmoreSearch() {
        
        loadmoreSearch = RACCommand() { (any:AnyObject!) -> RACSignal in
            
            // 查询
            let singal = self.strategyModelDataSourceProtocol.queryModelList(QueryModelListParams01())
            
            // 错误处理
            singal.subscribeError({ (error:NSError!) -> Void in
                
                self.setValue(error.localizedDescription, forKey: "errorMsg")
            })
            
            // 重置数据源
            singal.subscribeNextAs({ (strategyList:[StrategyModel]!) -> Void in
                
                self.setValue(self.strategyList + strategyList, forKey: "strategyList")
            })
            
            return singal
        }
    }
    
}
