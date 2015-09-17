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
            let hotHeaderModel      = CJCollectionViewHeaderModel(icon: nil, title: kTextHotSearch, type: CJCollectionViewHeaderModelTypeEnum.SingleClick, isExpend: false, isShowClearButton: false)
            let hotCellModels       = self.queryHotSearchData()
            
            // 历史搜索
            let historyHeaderModel  = CJCollectionViewHeaderModel(icon: nil, title: kTextHistorySearch, type: CJCollectionViewHeaderModelTypeEnum.SingleClick, isExpend: false, isShowClearButton: false)
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
            
            if keyword.length == 0 {
                
                subscriber.sendNext(nil)
                subscriber.sendCompleted()
                return nil
            }
            
            let stringArray = NSUserDefaults.standardUserDefaults().stringArrayForKey(kHistorySearchData)
            
            var newStringArray: [String]!
            if let stringArray = stringArray as? [String] {
                
                if NSMutableArray(array: stringArray).containsObject(keyword) {
                    
                    subscriber.sendNext(nil)
                    subscriber.sendCompleted()
                    return nil
                } else {
                    
                    newStringArray = stringArray + [keyword]
                    
                    if newStringArray.count > self.maxCount {
                        
                        newStringArray.removeAtIndex(0)
                    }
                }
                
            } else {
                
                newStringArray = [keyword]
            }
            
            NSUserDefaults.standardUserDefaults().setObject(newStringArray, forKey: kHistorySearchData)
            
            subscriber.sendNext(newStringArray)
            subscriber.sendCompleted()
            
            return nil
        })
    }
    
    func updateHotDataWithKeyword(keyword: String) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            if keyword.length == 0 {
                
                subscriber.sendNext(nil)
                subscriber.sendCompleted()
                return nil
            }
            
            let stringArray = NSUserDefaults.standardUserDefaults().stringArrayForKey(kHotSearchData)
            
            var newStringArray: [String]!
            if let stringArray = stringArray as? [String] {
                
                if NSMutableArray(array: stringArray).containsObject(keyword) {
                    
                    subscriber.sendNext(nil)
                    subscriber.sendCompleted()
                    return nil
                } else {
                    
                    newStringArray = stringArray + [keyword]
                }
                
            } else {
                
                newStringArray = [keyword]
            }
            
            NSUserDefaults.standardUserDefaults().setObject(newStringArray, forKey: kHotSearchData)
            
            subscriber.sendNext(newStringArray)
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
        
//        let stringArray = NSUserDefaults.standardUserDefaults().stringArrayForKey(kHotSearchData)
        let stringArray = ["衣服","裤子","外套","袜子","爽十一"]
        
        if let stringArray = stringArray as? [String] {
            
            for item in enumerate(stringArray) {
                
                let cellModel = CJCollectionViewCellModel(icon: nil, title: item.element)
                hotSearchData.append(cellModel)
            }
        }
        
        return hotSearchData
    }
}