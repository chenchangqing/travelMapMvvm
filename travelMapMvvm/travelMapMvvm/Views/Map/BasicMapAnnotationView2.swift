//
//  BasicMapAnnotationView2.swift
//  travelMap
//
//  Created by green on 15/7/22.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit

class BasicMapAnnotationView2: MKAnnotationView {
        
    var circleV: GCircleControl!
    var indexL: UILabel!
    
    var preventSelectionChange = false
    
    override func setSelected(selected: Bool, animated: Bool) {
        
        if !preventSelectionChange {
            
            super.setSelected(selected, animated: animated)
        }
    }
    
    override init!(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRectMake(0, 0, 16, 16)
        circleV = GCircleControl(frame: CGRectMake(0, 0, 16, 16))
        circleV.fillColor = UIColor.yellowColor()
        circleV.borderWidth = 0
        indexL = UILabel(frame: CGRectMake(0, 0, 16, 16))
        indexL.textAlignment = NSTextAlignment.Center
        indexL.font = UIFont.systemFontOfSize(14)
        self.addSubview(circleV)
        self.addSubview(indexL)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
