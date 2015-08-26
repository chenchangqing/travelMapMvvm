//
//  AbstractBusinessProtocol.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation

protocol AbstractBusinessProtocol {
    
    // 业务名称
    var title : String { get }
    
    // 业务是否可以执行
    var isValid : Bool { get }
    
    // 执行业务
    func execute()
    
    // 业务数据
    var businessModel : BusinessModel { get set }
}