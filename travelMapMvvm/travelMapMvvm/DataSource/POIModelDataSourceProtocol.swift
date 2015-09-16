//
//  POIModelDataSourceProtocol.swift
//  travelMapMvvm
//
//  Created by green on 15/9/11.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa
import Foundation

protocol POIModelDataSourceProtocol {
    
    /**
     * 攻略POI
     * 
     * @param strategyId 攻略ID
     * @param poiType 攻略类型
     * @param rows       行数
     * @param startId 从这ID开始查询
     *
     * @return  RACSignal
     */
    func queryPOIListByStrategyId(strategyId:String, poiType:POITypeEnum?,rows:Int, startId:String?) -> RACSignal
    
    
    /**
     * 城市POI
     *
     * @param cityId 城市ID
     * @param poiType 攻略类型
     * @param rows       行数
     * @param startId 从这ID开始查询
     *
     * @return  RACSignal
     */
    func queryPOIListByCityId(cityId:String, poiType:POITypeEnum?,rows:Int, startId:String?) -> RACSignal
    
    
    /**
     * 关键字POI
     *
     * @param keyword 关键字
     * @param poiType 攻略类型
     * @param rows       行数
     * @param startId 从这ID开始查询
     *
     * @return  RACSignal
     */
    func queryPOIListByKeyword(keyword:String, poiType:POITypeEnum?,rows:Int, startId:String?) -> RACSignal
    
    
    /**
     * 已收藏POI
     *
     * @param userId 用户ID
     * @param poiType 攻略类型
     * @param rows       行数
     * @param startId 从这ID开始查询
     *
     * @return  RACSignal
     */
    func queryPOIListByUserId(userId:String, poiType:POITypeEnum?,rows:Int, startId:String?) -> RACSignal
    
    
    /**
     * 某个POI周边的POI
     *
     * @param centerPoiId 某个POIID
     * @param poiType 攻略类型
     * @param rows       行数
     * @param startId 从这ID开始查询
     *
     * @return  RACSignal
     */
    func queryPOIListByCenterPOIId(centerPoiId:String, poiType:POITypeEnum?,rows:Int, startId:String?) -> RACSignal
}