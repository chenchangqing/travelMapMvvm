//
//  CLLocationCoordinate2DModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/12.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import MapKit

class CLLocationCoordinate2DModel: NSObject {
    
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        
        self.latitude   = latitude
        self.longitude  = longitude
    }
    
    // MARK: - 重写比较方法
    
    override func isEqual(object: AnyObject?) -> Bool {
        
        if let object=object as? CLLocationCoordinate2DModel {
            
            let selfCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let objCoordinate = CLLocationCoordinate2D(latitude: object.latitude, longitude: object.longitude)
            
            let distance = CaculateDistanceHelper.caculateDistance(selfCoordinate, toCoordinate: objCoordinate).double
            
            // 距离小于1米则相等
            if distance < 0.001 {
                
                return true
            }
        }
        return false
    }
    
    override var hash: Int {
        
        get {
            
            return "\(self.latitude)\(self.longitude)".hash
        }
    }
}
