//
//  IndexViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//


class IndexViewModel: IndexViewModelProtocol {
    
    private var strategyModelDataSourceProtocol = JSONStrategyModelDataSource.shareInstance()
    
    // MARK: - Implement
    
    var indexViewObservedModel =  IndexViewObservedModel()
    
    func refreshStrategyList() {
        
        strategyModelDataSourceProtocol.queryModelList(QueryModelListParams01(), callback: { (success, msg, data) -> Void in
            
            if success {
                
                if let data=data {
                    
                    self.indexViewObservedModel.setValue(data, forKey: pStrategyList)
                }
            }
        })
    }
    
    func loadmoreStrategyList() {
        
        strategyModelDataSourceProtocol.queryModelList(QueryModelListParams01(), callback: { (success, msg, data) -> Void in
            
            if success {
                
                if let data=data {
                    
                    self.indexViewObservedModel.mutableArrayValueForKey(pStrategyList).addObjectsFromArray(data)
                }
            }
        })
    }
}
