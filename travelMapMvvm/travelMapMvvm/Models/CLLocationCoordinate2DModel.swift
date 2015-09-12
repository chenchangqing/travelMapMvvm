//
//  CLLocationCoordinate2DModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/12.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit

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
            
            if object.latitude == self.latitude && object.longitude == self.longitude {
                
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
