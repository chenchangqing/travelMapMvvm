//
//  GCircleControl.swift
//  guanwawa
//
//  Created by green on 15-1-14.
//  Copyright (c) 2015年 city8. All rights reserved.
//

import UIKit

@IBDesignable class GCircleControl: UIControl {
    
    @IBInspectable var borderColor:UIColor  = UIColor.redColor()
    {
        willSet {
            shapeLayer.strokeColor = newValue.CGColor
        }
    }
    @IBInspectable var borderWidth:CGFloat  = 1
    {
        willSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var fillColor:UIColor    = UIColor.clearColor()
    {
        willSet {
            shapeLayer.fillColor = newValue.CGColor
        }
    }
    @IBInspectable var image:UIImage        = UIImage()
    {
        willSet {
            imageLayer.contents     = newValue.CGImage
        }
    }
    @IBInspectable var strokeStart:CGFloat  = 0
    {
        willSet {
            shapeLayer.strokeStart     = newValue
        }
    }
    @IBInspectable var strokeEnd:CGFloat    = 1
    {
        willSet {
            shapeLayer.strokeEnd     = newValue
        }
    }
    @IBInspectable var imageSize:CGSize           = CGSizeMake(0, 0)
    {
        willSet {
            imageLayer(newValue)
        }
    }
    
    
    private var bezierPath:UIBezierPath     = UIBezierPath()
    private var shapeLayer:CAShapeLayer     = CAShapeLayer()
    private var imageLayer:CALayer          = CALayer()
    private var halfWidth:CGFloat           = 0
    var radius:CGFloat                      = 0
    var arcCenter:CGPoint                   = CGPointMake(0, 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor    = UIColor.clearColor()
        shapeLayer.addSublayer(imageLayer)
        self.layer.addSublayer(shapeLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor    = UIColor.clearColor()
        shapeLayer.addSublayer(imageLayer)
        self.layer.addSublayer(shapeLayer)
    }
    
    func setBounds_(bounds:CGRect) {
        super.bounds = bounds
        
        self.setNeedsDisplay()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForInterfaceBuilder() {

    }
    
    override func drawRect(rect: CGRect) {
        
        halfWidth                   = min(self.bounds.width/2, self.bounds.height/2)
        arcCenter                   = CGPointMake(self.bounds.width/2, self.bounds.height/2)
        radius                      = halfWidth - borderWidth/2
        bezierPath                  = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
        shapeLayer.frame            = rect
        shapeLayer.masksToBounds    = true
        shapeLayer.path             = bezierPath.CGPath
        shapeLayer.strokeColor      = borderColor.CGColor
        shapeLayer.lineWidth        = borderWidth
        shapeLayer.fillColor        = fillColor.CGColor
        shapeLayer.strokeStart      = strokeStart
        shapeLayer.strokeEnd        = strokeEnd
        
        imageLayer(imageSize)
    }
    
    private func imageLayer(size:CGSize) {
        
        if CGSizeEqualToSize(size, CGSizeZero) {
            
            imageLayer.frame            = CGRectMake(borderWidth, borderWidth, (halfWidth - borderWidth)*2, (halfWidth - borderWidth)*2)
            imageLayer.cornerRadius     = halfWidth - borderWidth
            imageLayer.masksToBounds    = true
        } else {
            
            var x                       = halfWidth - size.width/2
            x                           = x < 0 ? 0 : x
            var y                       = halfWidth - size.height/2
            y                           = y < 0 ? 0 : y
            imageLayer.cornerRadius     = 0
            imageLayer.masksToBounds    = true
            imageLayer.frame            = CGRectMake(x, y, size.width, size.height)
        }
        imageLayer.contents         = image.CGImage
    }

}
