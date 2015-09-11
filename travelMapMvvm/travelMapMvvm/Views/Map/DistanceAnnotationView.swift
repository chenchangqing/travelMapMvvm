//
//  DistanceAnnotationView.swift
//  travelMap
//
//  Created by green on 15/7/23.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit

class DistanceAnnotationView: MKAnnotationView {
    
    var distanceL: UILabel!
    
    override init!(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRectMake(0, 0, 100, 21)
        self.centerOffset = CGPointMake(0, 21)
        self.backgroundColor = UIColor.clearColor()
        self.enabled = false
        
        distanceL = UILabel(frame: self.frame)
        distanceL.text = "100km"
        distanceL.font = UIFont.systemFontOfSize(14)
        distanceL.textAlignment = NSTextAlignment.Center
        distanceL.alpha = 0.0
        
        self.addSubview(distanceL)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
