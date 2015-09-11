//
//  POICallOutAnnotation.swift
//  travelMap
//
//  Created by green on 15/7/7.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit
import MapKit

class POICallOutAnnotation: CalloutMapAnnotation {
    
    var poiType: POITypeEnum = POITypeEnum.Scenic
    var poiName: String = ""
    var address: String = ""
    var baseAnnotation:BasicMapAnnotation2!
    
    init(latitude:CLLocationDegrees, longitude: CLLocationDegrees, poiType: POITypeEnum, poiName: String, address: String,baseAnnotation:BasicMapAnnotation2) {
        
        super.init()
        self.latitude = latitude
        self.longitude = longitude
        self.poiType = poiType
        self.poiName = poiName
        self.address = address
        self.baseAnnotation = baseAnnotation
    }
    
}
