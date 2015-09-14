//
//  CommentModelDataSourceProtocol.swift
//  travelMapMvvm
//
//  Created by green on 15/9/14.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa

protocol CommentModelDataSourceProtocol {
    
    /**
     * 查询POI评论列表
     *
     * @poiId      POIId
     * @rows       行数
     * @startId    从这ID开始查询
     *
     * @return  POI评论列表信号
     */
    func queryPOICommentList(poiId:String, rows:Int, startId:String?) -> RACSignal
}