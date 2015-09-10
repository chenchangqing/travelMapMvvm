//
//  POIModel.swift
//  travelMap
//
//  Created by green on 15/6/30.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit

// POI
class POIModel: NSObject, Deserializable {
    
    var poiId: String?          // ID
    var poiName: String?        // 名称
    var poiPicUrl: String?      // 图片地址
    var score: String?          // 评分
    var level: POILevelEnum?    // 星级
    var desc: String?           // 简介
    var address: String?        // 地址
    var openTime: String?       // 开放时间
    var ticketPrice: String?    // 票价
    var longitude: String?      // 经度
    var latitude: String?       // 纬度
    var poiType: POITypeEnum?   // POI类型
    var country: String?        // 国家
    var cityName: String?       // 城市
    var cityEnName: String?     // 城市英文
    
    override init() { }
    
    required init(data : [String:AnyObject]) {
        
        poiId           <-- data["poiId"]
        poiName         <-- data["poiName"]
        poiPicUrl       <-- data["poiPicUrl"]
        score           <-- data["score"]

        desc            <-- data["desc"]
        address         <-- data["address"]
        openTime        <-- data["openTime"]
        ticketPrice     <-- data["ticketPrice"]
        longitude       <-- data["longitude"]
        latitude        <-- data["latitude"]

        country         <-- data["country"]
        cityName        <-- data["cityName"]
        cityEnName      <-- data["cityEnName"]
        
        if let level=data["level"] as? String {
            
            self.level = POILevelEnum(rawValue: level)
        }
        
        if let poiType=data["poiType"] as? String {
            
            self.poiType = POITypeEnum(rawValue: poiType)
        }
    }
}

