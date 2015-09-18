//
//  CityModelDataSourceProtocol.swift
//  travelMapMvvm
//
//  Created by green on 15/9/18.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa

protocol CityModelDataSourceProtocol {
    
    /**
     * 城市列表
     * 
     * @param keyword 关键字
     *
     * @return 城市列表
     */
    func queryCityListByKeyword(keyword:String) -> RACSignal
}