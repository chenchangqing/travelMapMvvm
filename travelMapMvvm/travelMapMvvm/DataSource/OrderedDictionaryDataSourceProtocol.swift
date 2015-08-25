//
//  OrderedDictionaryProtocol.swift
//  CJMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

protocol OrderedDictionaryDataSourceProtocol {
    
    /**
    * 查询[headerModel:[cellModel]]字典
    */
    func queryDictionary(fileName:String) -> OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>
}
