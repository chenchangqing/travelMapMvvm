//
//  QueryCategoryDataViewModel.swift
//  CJMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class QueryCategoryDataViewModel: QueryCategoryDataViewModelProtocol {
    
    // MARK: - Private
    
    private var command : QueryCategoryDataCommandProtocol!
    
    // MARK: - Public
    
    var dataSource : OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]> {
        
        get {
            
            return command.dataSource
        }
    }
    
    /**
    * 单例
    */
    class func shareInstance(fileName: String) -> QueryCategoryDataViewModelProtocol{
        
        struct CJSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:QueryCategoryDataViewModelProtocol? = nil
        }
        
        dispatch_once(&CJSingleton.predicate,{
            
            CJSingleton.instance=QueryCategoryDataViewModel(fileName: fileName)
        })
        return CJSingleton.instance!
    }
    
    init(fileName:String) {
        
        self.command = QueryCategoryDataCommand.shareInstance(fileName)
    }
}
