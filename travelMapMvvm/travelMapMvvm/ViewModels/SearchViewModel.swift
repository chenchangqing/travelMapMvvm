//
//  SearchViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/17.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveViewModel

class SearchViewModel: RVMViewModel {
    
    // MARK: - 提示信息
    
    dynamic var failureMsg  : String = ""   // 操作失败提示
    dynamic var successMsg  : String = ""   // 操作失败提示
    
    // MARK: - DATA
    
    dynamic var searchViewData = DataSource(dataSource: OrderedDictionary<CJCollectionViewHeaderModel, [CJCollectionViewCellModel]>())
    
    // MARK: - Commands
    
    var querySearchViewDataCommand: RACCommand! // 查询历史、热门数据命令
    var updateHistoryDataCommand: RACCommand!   // 更新历史搜索数据命令
    
    private let searchViewDataSourceProtocol = SearchViewDataSource.shareInstance()
    
    // MARK: - Init
    
    override init() {
        
        super.init()
        
        setUpCommands()
    }
    
    // MARK: - Set Up Commands
    
    private func setUpCommands() {
        
        querySearchViewDataCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            return self.searchViewDataSourceProtocol.querySearchViewData().materialize()
        })
        
        updateHistoryDataCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            return self.searchViewDataSourceProtocol.updateHistoryDataWithKeyword(any as! String).materialize()
            
        })
        
        self.didBecomeActiveSignal.subscribeNext { (any:AnyObject!) -> Void in
            
            self.querySearchViewDataCommand.execute(nil)
        }
    }
}