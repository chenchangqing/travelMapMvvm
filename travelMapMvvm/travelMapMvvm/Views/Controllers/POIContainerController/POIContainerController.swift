//
//  POIContainerController.swift
//  travelMapMvvm
//
//  Created by green on 15/9/15.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import ReactiveCocoa

class POIContainerController: UIViewController {
    
    // MARK: - View Model
    
    var poiContainerViewModel: POIContainerViewModel!
    
    // MARK: - 切换地图或列表按钮
    
    @IBOutlet weak var rightBtn: UIBarButtonItem!
    
    // MARK: - 子视图控制器
    
    private var mapViewController   : UIViewController!
    private var listViewController  : UIViewController!
    
    // MARK: - 当前显示的视图控制器
    
    private var currentViewController: UIViewController!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let poiTypeViewController=segue.destinationViewController as? POITypeViewController {
            
            poiTypeViewController.poiTypeViewModel = POITypeViewModel(poiContainerViewModel: self.poiContainerViewModel)
        }
    }
    
    // MARK: - Set Up
    
    private func setUp() {
        
        setUpTitle()
        setUpRightButton()
        setUpCurrentViewController()
        setUpChildViewControllers()
    }
    
    // MARK: - Set Up Title
    
    private func setUpTitle() {
     
        self.title = ShowPoiModeEnum.List.rawValue
    }
    
    // MARK: - Set Up Right Button
    
    private func setUpRightButton() {
        
        rightBtn.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.grayColor()], forState: UIControlState.Highlighted)
    }
    
    // MARK: - Set Up CurrentViewController
    
    private func setUpCurrentViewController() {
        
        self.currentViewController = self.childViewControllers[1] as! UIViewController
    }
    
    // MARK: - Set Up ChildViewControllers
    
    private func setUpChildViewControllers() {
        
        self.mapViewController  = self.childViewControllers[0] as! UIViewController
        self.listViewController = self.childViewControllers[1] as! UIViewController
    }
    
    // MARK: - Set Up Event
    
    @IBAction func rightBtnClicked(sender:UIBarButtonItem) {
        
        var willShowViewController: UIViewController!
        
        // 切换至地图模式        
        if self.title == ShowPoiModeEnum.List.rawValue {
            
            willShowViewController = self.mapViewController
            
            self.title = ShowPoiModeEnum.Map.rawValue
        }
        
        else
        
        // 切换至列表模式
        if self.title == ShowPoiModeEnum.Map.rawValue {
            
            willShowViewController = self.listViewController
            
            self.title = ShowPoiModeEnum.List.rawValue
        }
        
        // 动画切换
        sender.enabled = false
        self.transitionFromViewController(self.currentViewController, toViewController: willShowViewController, duration: 0.3, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
            
        }, completion: { (finished) -> Void in
            
            if finished {
               
                willShowViewController.didMoveToParentViewController(self)
                self.currentViewController = willShowViewController
            }
            sender.enabled = true
        })
    }

}
