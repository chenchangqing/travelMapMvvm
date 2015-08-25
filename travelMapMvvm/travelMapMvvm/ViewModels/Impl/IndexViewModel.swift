//
//  IndexViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//


class IndexViewModel: IndexViewModelProtocol {
    
    // MARK: - 单例
    
    class func shareInstance(callback: NetReuqestCallBack)->IndexViewModelProtocol{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:IndexViewModelProtocol? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance=IndexViewModel(callback: callback)
        })
        return YRSingleton.instance!
    }
    
    private var business : QueryIndexPageStrategyListBusinessProtocol!

    // MARK: - implement
    
    func queryIndexPageStrategyList() {
        
        business.execute()
    }
    
    // MARK: - init
    
    init(callback: NetReuqestCallBack) {
        
        business = QueryIndexPageStrategyListBusiness.shareInstance(callback)
    }
}
