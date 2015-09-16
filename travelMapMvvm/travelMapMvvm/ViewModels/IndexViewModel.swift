//
//  IndexViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa
import ReactiveViewModel

class IndexViewModel: RVMViewModel {
    
//    private var strategyModelDataSourceProtocol = NetworkStrategyModelDataSource.shareInstance()
    private var strategyModelDataSourceProtocol = JSONStrategyModelDataSource.shareInstance()
    
    dynamic var strategyList = [StrategyModel]()    // 数据源（一直处于被观察状态）
    dynamic var errorMsg: String = ""               // 错误信息
    
    var refreshSearch : RACCommand!     // 下拉刷新操作
    var loadmoreSearch : RACCommand!    // 上拉加载更多操作
    
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
            
            return self.strategyModelDataSourceProtocol.queryStrategyListBySystem(StrategyThemeEnum.allValues, strategyMonthArray: MonthEnum.allValues, strategyTypeArray: StrategyTypeEnum.allValues, order: StrategyOrderEnum.Default, rowCount: 5, startId: nil)
        }
        
        refreshSearch.errors.subscribeNextAs { (error:NSError!) -> Void in
            
            self.setValue(error.localizedDescription, forKey: "errorMsg")
            self.setValue([StrategyModel](), forKey: "strategyList")
        }
        
        refreshSearch.executionSignals.switchToLatest().subscribeNextAs({ (strategyList:[StrategyModel]!) -> Void in
            
            self.setValue(strategyList, forKey: "strategyList")
        })
    }
    
    /**
     * 初始化上拉加载
     */
    private func setupLoadmoreSearch() {
        
        loadmoreSearch = RACCommand() { (any:AnyObject!) -> RACSignal in
            
            return self.strategyModelDataSourceProtocol.queryStrategyListBySystem(StrategyThemeEnum.allValues, strategyMonthArray: MonthEnum.allValues, strategyTypeArray: StrategyTypeEnum.allValues, order: StrategyOrderEnum.Default, rowCount: 5, startId: nil)
        }
        
        loadmoreSearch.errors.subscribeNextAs { (error:NSError!) -> Void in
            
            self.setValue(error.localizedDescription, forKey: "errorMsg")
        }
        
        loadmoreSearch.executionSignals.switchToLatest().subscribeNextAs({ (strategyList:[StrategyModel]!) -> Void in
            
            self.strategyList += strategyList
        })
    }
    
}
