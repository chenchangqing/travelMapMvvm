//
//  FilterViewModjel.swift
//  travelMapMvvm
//
//  Created by green on 15/8/31.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit

class FilterViewModel: NSObject {
   
    private var selectionViewDataSourceProtocol:SelectionViewDataSourceProtocol = SelectionViewDataSource.shareInstance()
    
    // 数据源
    var filterSelectionDic :OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>!
    
    override init() {
        
        filterSelectionDic = selectionViewDataSourceProtocol.queryFilterDictionary()
    }
}
