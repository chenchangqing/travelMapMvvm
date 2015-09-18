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
    
    // MARK: - 历史搜索最多显示个数
    
    private let maxCount:Int = 4
    
    // MARK: - 单例
    
    class func shareInstance()->SearchViewDataSourceProtocol{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:SearchViewDataSource? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance=SearchViewDataSource()
        })
        return YRSingleton.instance!
    }
    
    func querySearchViewData() -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            // 热门搜索
            let hotHeaderModel      = CJCollectionViewHeaderModel(icon: nil, title: kTextHotSearch, type: CJCollectionViewHeaderModelTypeEnum.SingleClick, isExpend: true, isShowClearButton: false)
            let hotCellModels       = self.queryHotSearchData()
            
            // 历史搜索
            let historyHeaderModel  = CJCollectionViewHeaderModel(icon: nil, title: kTextHistorySearch, type: CJCollectionViewHeaderModelTypeEnum.SingleClick, isExpend: true, isShowClearButton: false)
            let historyCellModels   = self.queryHistorySearchData()
            
            var dataSource = OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>()
            dataSource[hotHeaderModel]      = hotCellModels
            dataSource[historyHeaderModel]  = historyCellModels
            
            subscriber.sendNext(DataSource(dataSource: dataSource))
            subscriber.sendCompleted()
            
            return nil
        })
    }
    
    func updateHistoryDataWithKeyword(keyword: String) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            if let newStringArray = self.updateHistoryOrHotDataWithKeyword(keyword, dataKey: kHistorySearchData) {
                
                subscriber.sendNext(newStringArray)
                subscriber.sendCompleted()
            } else {
                
                subscriber.sendNext(nil)
                subscriber.sendCompleted()
            }
            
            return nil
        })
    }
    
    func updateHotDataWithKeyword(keyword: String) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            if let newStringArray = self.updateHistoryOrHotDataWithKeyword(keyword, dataKey: kHotSearchData) {
                
                subscriber.sendNext(newStringArray)
                subscriber.sendCompleted()
            } else {
                
                subscriber.sendNext(nil)
                subscriber.sendCompleted()
            }
            
            return nil
        })
    }
    
    private func updateHistoryOrHotDataWithKeyword(keyword: String,dataKey: String) -> [String]? {
            
        if keyword.length == 0 {
            
            return nil
        }
        
        let stringArray = NSUserDefaults.standardUserDefaults().stringArrayForKey(dataKey)

        var newStringArray: [String]!
        if let stringArray = stringArray as? [String] {
            
            if NSMutableArray(array: stringArray).containsObject(keyword) {
                
                newStringArray = stringArray + [keyword]
                newStringArray.removeAtIndex(NSMutableArray(array: stringArray).indexOfObject(keyword))                } else {
                
                newStringArray = stringArray + [keyword]
                
                if newStringArray.count > self.maxCount {
                    
                    newStringArray.removeAtIndex(0)
                }
            }
            
        } else {
            
            newStringArray = [keyword]
        }
        
        NSUserDefaults.standardUserDefaults().setObject(newStringArray, forKey: dataKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    
        return newStringArray
    }
    
    /**
     * 查询历史搜索
     */
    private func queryHistorySearchData() -> [CJCollectionViewCellModel] {
        
        var historySearchData = [CJCollectionViewCellModel]()
        
        let stringArray = NSUserDefaults.standardUserDefaults().stringArrayForKey(kHistorySearchData)
        
        if let stringArray = stringArray as? [String] {
            
            for (var i=stringArray.count-1;i>=0;i--) {
                
                let cellModel = CJCollectionViewCellModel(icon: nil, title: stringArray[i])
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
        
//        let stringArray = NSUserDefaults.standardUserDefaults().stringArrayForKey(kHotSearchData)
        let stringArray = ["衣服","裤子","外套","袜子","爽十一"]
        
        if let stringArray = stringArray as? [String] {
            
            for (var i=stringArray.count-1;i>=0;i--) {
                
                let cellModel = CJCollectionViewCellModel(icon: nil, title: stringArray[i])
                hotSearchData.append(cellModel)
            }
        }
        
        return hotSearchData
    }
}