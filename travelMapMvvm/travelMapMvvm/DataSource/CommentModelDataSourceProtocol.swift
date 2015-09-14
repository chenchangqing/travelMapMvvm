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
     * @param   poiId      POIId
     * @param   rows       行数
     * @param   startId    从这ID开始查询
     *
     * @return  POI评论列表信号
     */
    func queryPOICommentList(poiId:String, rows:Int, startId:String?) -> RACSignal
    
    /**
     * 新增评论
     * 
     * @param content 评论内容
     * @param level   评分
     * @param poiId   POIId
     * 
     * @return 新增评论信号
     */
    func addPOIComment(content:String,level:POILevelEnum,poiId:String) -> RACSignal
}