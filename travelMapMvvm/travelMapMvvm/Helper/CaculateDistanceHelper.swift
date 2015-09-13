//
//  CaculateDistanceHelper.swift
//  travelMapMvvm
//
//  Created by green on 15/9/13.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit

class CaculateDistanceHelper: NSObject {
    
    /**
     * 计算距离
     */
    class func caculateDistance(fromCoordinate:CLLocationCoordinate2D,toCoordinate:CLLocationCoordinate2D) -> (str:String,double:Double) {
        
        let fromLocation    = CLLocation(latitude: fromCoordinate.latitude, longitude: fromCoordinate.longitude)
        let toLocation      = CLLocation(latitude: toCoordinate.latitude, longitude: toCoordinate.longitude)
        let distance        = fromLocation.distanceFromLocation(toLocation)
        let doubleDistance  = distance/1000
        let b               = doubleDistance * 100
        let c               = Double(Int(b)) / 100
        return ("\(c)km",c)
    }
}
