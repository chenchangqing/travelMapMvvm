//
//  QueryIndexPageStrategyListBusiness.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit

class QueryIndexPageStrategyListBusiness: NSObject, QueryIndexPageStrategyListBusinessProtocol {
    
    
    // MARK: - 单例
    
    class func shareInstance()->QueryIndexPageStrategyListBusinessProtocol{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:QueryIndexPageStrategyListBusinessProtocol? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance=QueryIndexPageStrategyListBusiness()
        })
        return YRSingleton.instance!
    }
    
    private var dataSourceProtocol : StrategyModelDataSourceProtocol!
   
    // MARK: - implement
    
    var title : String {
        
        get {
            
            return "查询首页小编推荐的攻略"
        }
    }
    
    var isValid : Bool {
        
        get {
            
            return true
        }
    }
    
    var businessModel = BusinessModel()
    
    func execute() {
        
        dataSourceProtocol.queryModelList(QueryModelListParams01(), callback: { (success, msg, data) -> Void in
            
//            println(self.businessModel)
            
            self.businessModel.setValue(success, forKey: kSuccess)
            self.businessModel.setValue(msg, forKey: kMsg)
            self.businessModel.setValue(data, forKey: kData)
            
//            println(self.businessModel)
        })
    }
    
    // MARK: - init
    
    override init() {
        
        dataSourceProtocol = JSONStrategyModelDataSource.shareInstance()
    }
}
