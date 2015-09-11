//
//  BasicMapAnnotation2.swift
//  travelMap
//
//  Created by green on 15/7/22.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit

class BasicMapAnnotation: MKPointAnnotation {

    var index: Int = 0
    
    init(latitude:CLLocationDegrees, longitude: CLLocationDegrees, index: Int) {
        
        super.init()
        super.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.index = index
    }
    
    // MARK: - 重写比较方法
    
    override func isEqual(object: AnyObject?) -> Bool {
        
        if let object=object as? BasicMapAnnotation {
            
            if object.coordinate.latitude == self.coordinate.latitude && object.coordinate.longitude == self.coordinate.longitude {
                
                return true
            }
        }
        return false
    }
    
    override var hash: Int {
        
        get {
            
            return "\(self.coordinate.latitude)\(self.coordinate.longitude)".hash
        }
    }
}
