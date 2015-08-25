//
//  QueryCategoryDataCommandProtocol.swift
//  CJMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

protocol QueryCategoryDataCommandProtocol {
    
    var dataSource : OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]> { get }
}
