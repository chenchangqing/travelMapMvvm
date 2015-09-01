//
//  SelectionViewDataSourceProtocol.swift
//  travelMapMvvm
//
//  Created by green on 15/8/31.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa

/**
 * 为选择控件提供数据
 */
protocol SelectionViewDataSourceProtocol {
    
    /**
     * 查询筛选条件数据
     * 
     * return 信号
     */
    func queryFilterDictionary() -> RACSignal
    
    /**
     * 查询查询排序数据
     * 
     * @param cellWidth 指定cell宽度
     *
     * @return 信号
     */
    func queryOrderDictionary(cellWidth:CGFloat) -> RACSignal
}

class DataSource:NSObject {
    
    var dataSource=OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>()
    
    init(dataSource:OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>) {
        self.dataSource = dataSource
    }
}