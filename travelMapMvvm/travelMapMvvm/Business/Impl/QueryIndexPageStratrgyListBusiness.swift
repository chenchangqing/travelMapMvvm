//
//  QueryIndexPageStrategyListBusiness.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit

class QueryIndexPageStrategyListBusiness: QueryIndexPageStrategyListBusinessProtocol {
    
    
    // MARK: - 单例
    
    class func shareInstance(callback: NetReuqestCallBack)->QueryIndexPageStrategyListBusinessProtocol{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:QueryIndexPageStrategyListBusinessProtocol? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance=QueryIndexPageStrategyListBusiness(callback: callback)
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
    
    var callback : NetReuqestCallBack = { (success,msg,data) in }
    
    func execute() {
        
        dataSourceProtocol.queryModelList(QueryModelListParams01(), callback: { (success, msg, data) -> Void in
            
            self.dataSourceProtocol.queryModelList(QueryModelListParams01(), callback: { (success, msg, data) -> Void in
                
                self.callback(success: success, msg: msg, data: data)
            })
        })
    }
    
    // MARK: - init
    
    init(callback: NetReuqestCallBack) {
        
        self.callback = callback
        dataSourceProtocol = JSONStrategyModelDataSource.shareInstance()
    }
}
