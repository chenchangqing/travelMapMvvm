//
//  QueryCategoryDataCommand.swift
//  CJMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import Foundation

class QueryCategoryDataCommand : QueryCategoryDataCommandProtocol {
    
    // MARK: - Private P
    
    private var dataSourceProtocol : OrderedDictionaryDataSourceProtocol!
    private var fileName: String!
    
    // MARK: - Public P
    
    var dataSource : OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]> {
        
        get {
            
            return self.dataSourceProtocol.queryDictionary(fileName)
        }
    }
    
    // MARK: - 单例
    
    class func shareInstance(fileName: String) -> QueryCategoryDataCommandProtocol{
        
        struct CJSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:QueryCategoryDataCommandProtocol? = nil
        }
        
        dispatch_once(&CJSingleton.predicate,{
            
            CJSingleton.instance=QueryCategoryDataCommand(fileName: fileName)
        })
        return CJSingleton.instance!
    }
    
    init(fileName: String) {
        
        self.fileName           = fileName
        dataSourceProtocol      = DatabaseOrderedDictionaryDataSource.shareInstance()
    }
}
