//
//  BottomLineCell.swift
//  travelMap
//
//  Created by green on 15/6/29.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit

class BottomLineCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.contentView.layer.addSublayer(bottomShapeLayer)
    }
    
    private var bottomShapeLayer = CAShapeLayer()
    private var bottomPath = UIBezierPath()
    
    override func drawRect(rect: CGRect) {
        
        bottomPath.moveToPoint(CGPointMake(0, rect.height - 0.5))
        bottomPath.addLineToPoint(CGPointMake(rect.width, rect.height - 0.5))
        
        bottomShapeLayer.frame = rect
        bottomShapeLayer.path = bottomPath.CGPath
        bottomShapeLayer.backgroundColor = UIColor.clearColor().CGColor
        bottomShapeLayer.strokeColor = UITableViewCell.bottomLineColor.CGColor
        bottomShapeLayer.lineWidth = 1
    }

}
