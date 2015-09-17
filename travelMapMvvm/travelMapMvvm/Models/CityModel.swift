//
//  CityModel.swift
//  travelMap
//
//  Created by green on 15/6/23.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

// 城市信息
class CityModel: NSObject, Deserializable {
   
    var cityId: String?      // ID
    var cityName: String?    // 城市名称
    var cityEnName: String?  // 英文名
    var cityPicUrl: String?  // 城市图片地址
    var country: String?     // 国家
    
    override init() { }
    
    required init(data : [String:AnyObject]) {
        
        cityId           <-- data["cityId"]
        cityName         <-- data["cityName"]
        cityEnName       <-- data["cityEnName"]
        cityPicUrl       <-- data["cityPicUrl"]
        country          <-- data["country"]
    }
}
