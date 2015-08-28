//
//  UIViewController+IndicatorView.swift
//  travelMap
//
//  Created by green on 15/8/24.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import Foundation

extension UIViewController {
    
    var indicatorView: NVActivityIndicatorView {
        
        get {
            
            var indicatorViewRect:CGRect!
            var indicatorView:NVActivityIndicatorView!
            var parentView:UIView!
            
            if let navigationController=self.navigationController {
                
                indicatorViewRect = CGRectMake(0, 64, CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds) - 64)
                parentView = navigationController.view
            } else {
                
                indicatorViewRect = CGRectMake(0, 20, CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetWidth(UIScreen.mainScreen().bounds) - 20)
                parentView = self.view
            }
            
            for subview in parentView.subviews {
                
                if subview is NVActivityIndicatorView {
                    
                    return subview as! NVActivityIndicatorView
                }
            }
            
            indicatorView = NVActivityIndicatorView(frame: indicatorViewRect, type: NVActivityIndicatorType.LineScalePulseOutRapid, color: UIColor.blueColor(), size: CGSizeMake(40, 40))
            indicatorView.backgroundColor = UIColor.whiteColor()
            
            parentView.addSubview(indicatorView)
            
            parentView.bringSubviewToFront(indicatorView)
            
            return indicatorView
        }
    }
}