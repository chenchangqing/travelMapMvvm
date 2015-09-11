//
//  DistanceAnnotation.swift
//  travelMap
//
//  Created by green on 15/7/23.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit
import MapKit

class DistanceAnnotation: MKPointAnnotation {
    
    var distance: String!
    
    init(latitude:CLLocationDegrees, longitude: CLLocationDegrees, distance: String) {
        
        super.init()
        super.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.distance = distance
    }
}
