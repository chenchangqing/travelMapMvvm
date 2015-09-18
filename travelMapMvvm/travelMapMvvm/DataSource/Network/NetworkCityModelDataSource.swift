//
//  NetworkCityModelDataSource.swift
//  travelMapMvvm
//
//  Created by green on 15/9/18.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa

class NetworkCityModelDataSource: CityModelDataSourceProtocol {
    
    // MARK: - 单例
    
    class func shareInstance()->CityModelDataSourceProtocol{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:JSONCityModelDataSource? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance=JSONCityModelDataSource()
        })
        return YRSingleton.instance!
    }
    
    func queryCityListByKeyword(keyword: String) -> RACSignal {
        
        return RACSignal.empty()
    }
}
