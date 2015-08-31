//
//  SelectionViewDataSourceProtocol.swift
//  travelMapMvvm
//
//  Created by green on 15/8/31.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

/**
 * 为选择控件提供数据
 */
protocol SelectionViewDataSourceProtocol {
    
    /**
     * 查询筛选条件数据
     * 
     * return 数据字典
     */
    func queryFilterDictionary() -> OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>
    
    /**
     * 查询查询排序数据
     * 
     * @param cellWidth 指定cell宽度
     *
     * @return 数据字典
     */
    func queryOrderDictionary(cellWidth:CGFloat) -> OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>
}