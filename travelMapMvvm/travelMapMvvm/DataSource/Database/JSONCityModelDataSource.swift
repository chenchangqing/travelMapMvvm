//
//  CityModelDataSource.swift
//  travelMapMvvm
//
//  Created by green on 15/9/18.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa

class JSONCityModelDataSource: CityModelDataSourceProtocol {
    
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
    
    func queryCityListByKeyword(keyword:String) -> RACSignal {
        
        return  RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 1)), dispatch_get_main_queue(), { () -> Void in
                
                let resultDic = ReadJsonClass.readJsonData("queryCityList")
                
                if resultDic.error == nil {
                    
                    if let data: AnyObject=resultDic.data {
                        
                        var list = [CityModel]()
                        
                        list <-- data[kData]
                        
                        subscriber.sendNext(list)
                        subscriber.sendCompleted()
                    } else {
                        
                        subscriber.sendError(ErrorEnum.JSONError.error)
                        
                    }
                } else {
                    
                    subscriber.sendError(resultDic.error!)
                }
            })
            
            return nil
        })
    }
}