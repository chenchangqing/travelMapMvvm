//
//  IndexViewModelProtocol.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation

protocol IndexViewModelProtocol : AbstractViewModelProtocol {
    
    var queryIndexPageStrategyListBusiness : QueryIndexPageStrategyListBusinessProtocol { get }
}