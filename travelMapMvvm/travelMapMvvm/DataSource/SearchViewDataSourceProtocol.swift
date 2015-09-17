//
//  SearchViewDataSourceProtocol.swift
//  travelMapMvvm
//
//  Created by green on 15/9/17.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa

protocol SearchViewDataSourceProtocol {
    
    /**
     * 历史搜索数据、热门搜索数据
     */
    func querySearchViewData() -> RACSignal
    
}