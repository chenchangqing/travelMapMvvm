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
     * 
     * @return OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>()
     */
    func querySearchViewData() -> RACSignal
    
    /**
     * 更新历史搜索
     * 
     * @param keyword 搜索字符
     * 
     * @return Bool 是否更新
     */
    func updateHistoryDataWithKeyword(keyword:String) -> RACSignal
    
    /**
     * 更新热门搜索
     *
     * @param keyword 搜索字符
     *
     * @return Bool 是否更新
     */
    func updateHotDataWithKeyword(keyword:String) -> RACSignal
}