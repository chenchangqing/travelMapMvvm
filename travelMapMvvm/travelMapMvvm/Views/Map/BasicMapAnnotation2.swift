//
//  BasicMapAnnotation2.swift
//  travelMap
//
//  Created by green on 15/7/22.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit

class BasicMapAnnotation2: MKPointAnnotation {

    var index: Int = 0
    
    init(latitude:CLLocationDegrees, longitude: CLLocationDegrees, index: Int) {
        
        super.init()
        super.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.index = index
    }
}
