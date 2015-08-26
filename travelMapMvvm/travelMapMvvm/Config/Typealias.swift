//
//  Typealias.swift
//  travelMapMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

// 回调函数别名
typealias NetReuqestCallBack = (success:Bool,msg:String?,data:AnyObject?) -> Void
typealias NetReuqestCallBackForStrategyModelArray = (success:Bool,msg:String?,data:[StrategyModel]?) -> Void
typealias NetRequestCallBackForDownloadImage = (success:Bool,msg:String?,data:UIImage?) -> Void
