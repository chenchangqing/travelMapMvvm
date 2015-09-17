//
//  SearchViewDataSource.swift
//  travelMapMvvm
//
//  Created by green on 15/9/17.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa

class SearchViewDataSource: SearchViewDataSourceProtocol {
    
    func querySearchViewData() -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            // 热门搜索
            let hotHeaderModel      = CJCollectionViewHeaderModel(icon: nil, title: kTextHotSearch)
            let hotCellModels       = self.queryHotSearchData()
            
            // 历史搜索
            let historyHeaderModel  = CJCollectionViewHeaderModel(icon: nil, title: kTextHistorySearch)
            let historyCellModels   = self.queryHistorySearchData()
            
            var dataSource = OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>()
            dataSource[hotHeaderModel]      = hotCellModels
            dataSource[historyHeaderModel]  = historyCellModels
            
            subscriber.sendNext(DataSource(dataSource: dataSource))
            subscriber.sendCompleted()
            
            return nil
        })
    }
    
    /**
     * 查询历史搜索
     */
    private func queryHistorySearchData() -> [CJCollectionViewCellModel] {
        
        var historySearchData = [CJCollectionViewCellModel]()
        
        let stringArray = NSUserDefaults.standardUserDefaults().stringArrayForKey(kHotSearchData)
        
        if let stringArray = stringArray as? [String] {
            
            for item in enumerate(stringArray) {
                
                let cellModel = CJCollectionViewCellModel(icon: nil, title: item.element)
                historySearchData.append(cellModel)
            }
        }
        
        return historySearchData
    }
    
    /**
     * 查询热门搜索
     */
    private func queryHotSearchData() -> [CJCollectionViewCellModel] {
        
        var hotSearchData = [CJCollectionViewCellModel]()
        
        let stringArray = NSUserDefaults.standardUserDefaults().stringArrayForKey(kHotSearchData)
        
        if let stringArray = stringArray as? [String] {
            
            for item in enumerate(stringArray) {
                
                let cellModel = CJCollectionViewCellModel(icon: nil, title: item.element)
                hotSearchData.append(cellModel)
            }
        }
        
        return hotSearchData
    }
}