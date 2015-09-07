//
//  UIViewController+IndicatorView.swift
//  travelMap
//
//  Created by green on 15/8/24.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import Foundation

extension UIViewController :UITextFieldDelegate {
    
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
            indicatorView.hidesWhenStopped = false
            indicatorView.hidden = true
            
            parentView.addSubview(indicatorView)
            
            parentView.bringSubviewToFront(indicatorView)
            
            return indicatorView
        }
    }
    
    /**
     * 从storyboard中加载ViewController
     */
    class func getViewController(storyboardName:String,identifier:String) -> UIViewController? {
        
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(identifier) as? UIViewController
    }
    
    /**
     * dissmiss modal
     */
    @IBAction func dissSelfAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     * 动画
     */
    func executeFadeAnimation() {
        
        var animated = CATransition()
        animated.duration = 5.0
        animated.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animated.type = kCATransitionFade
        animated.removedOnCompletion = true
        
        self.view.layer.addAnimation(animated, forKey: nil)
    }
    
    /**
     * 开始提示动画
     */
    func startIndicatorAnimation() {
        
        if self.indicatorView.hidden {
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in

                self.indicatorView.alpha = 1
            }, completion: { (isfinished:Bool) -> Void in
                
                self.indicatorView.startAnimation()
            })
        }
    }
    
    /**
     * 停止提示动画
     */
    func stopIndicatorAnimation() {
        
        if !self.indicatorView.hidden {
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.indicatorView.alpha = 0
            }, completion: { (isfinished:Bool) -> Void in
                
                self.indicatorView.hidden = true
                self.indicatorView.stopAnimation()
                self.executeFadeAnimation()
            })
        }
    }

}