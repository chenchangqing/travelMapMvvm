//
//  DesViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/8/31.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit

class DesViewModel: NSObject {
    
    private var selectionViewDataSourceProtocol:SelectionViewDataSourceProtocol = SelectionViewDataSource.shareInstance()
    
    // 数据源
    var desSelectionDic :OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>!
    
    init(cellWidth:CGFloat) {
        
        desSelectionDic = selectionViewDataSourceProtocol.queryOrderDictionary(cellWidth)
    }
}
