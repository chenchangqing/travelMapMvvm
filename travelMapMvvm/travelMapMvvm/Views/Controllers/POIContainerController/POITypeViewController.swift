//
//  ViewController.swift
//  SSASideMenu+HMSegment+SwipeView
//
//  Created by green on 15/9/15.
//  Copyright (c) 2015年 chenchangqing. All rights reserved.
//

import UIKit

class POITypeViewController: UIViewController, SwipeViewDataSource, SwipeViewDelegate, SSASideMenuDelegate {
    
    // MARK: - View Model
    
    var poiTypeViewModel: POITypeViewModel!
    
    // MARK: - UI HMSegmentedControl/SwipeView
    
    @IBOutlet var segmentedControl  : HMSegmentedControl!
    @IBOutlet var swipeView         : SwipeView!
    
    // MARK: - 页面切换时间
    
    let kDuration:Double = 0.3
    
    // MARK: - Items
    
    var items:OrderedDictionary<NSNumber,UIColor> = {
    
        var items = OrderedDictionary<NSNumber,UIColor>()
        
        items[0] = UIColor.greenColor()
        items[1] = UIColor.redColor()
        items[2] = UIColor.grayColor()
        items[3] = UIColor.blueColor()
        items[4] = UIColor.magentaColor()
        
        return items
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    deinit {
        
        swipeView.delegate = nil
        swipeView.dataSource = nil
    }

    // MARK: - Set Up
    
    private func setUp() {
        
        setUpSegmentedControl()
        setUpChildViewController()
        setUpSwipeView()
    }
    
    // MARK: - Set Up SegmentedControl
    
    private func setUpSegmentedControl() {
        
        var titles = [String]()
        
        for item in self.poiTypeViewModel.segmentedControlItems {
            
            titles.append(item.rawValue)
        }
        
        segmentedControl.sectionTitles               = titles
        segmentedControl.selectionIndicatorHeight    = 2.0
        segmentedControl.selectionIndicatorColor     = UIColor.blueColor()
        segmentedControl.selectionIndicatorLocation  = HMSegmentedControlSelectionIndicatorLocationDown
        segmentedControl.backgroundColor             = UIColor.lightGrayColor()
        segmentedControl.titleTextAttributes         = [NSFontAttributeName:UIFont.systemFontOfSize(14)]
        segmentedControl.shouldAnimateUserSelection  = true
        segmentedControl.selectionStyle              = HMSegmentedControlSelectionStyleFullWidthStripe
        
        segmentedControl.indexChangeBlock = { (index:NSInteger) in
        
            self.swipeView.scrollToPage(index, duration: self.kDuration)
        }
        
        self.view.addSubview(segmentedControl)
    }
    
    // MARK: - Set Up ChildViewController
    
    private func setUpChildViewController() {
        
        let queryPOIListScenicCommand   = self.poiTypeViewModel.poiContainerViewModel.queryPOIListScenicCommand
        let queryPOIListFoodCommand     = self.poiTypeViewModel.poiContainerViewModel.queryPOIListFoodCommand
        let queryPOIListShoppingCommand = self.poiTypeViewModel.poiContainerViewModel.queryPOIListShoppingCommand
        let queryPOIListHotelCommand    = self.poiTypeViewModel.poiContainerViewModel.queryPOIListHotelCommand
        let queryPOIListActivityCommand = self.poiTypeViewModel.poiContainerViewModel.queryPOIListActivityCommand
        
        switch (self.poiTypeViewModel.showPoiMode) {
            
        case .Map:  // 地图模式
            
            for item in enumerate(self.poiTypeViewModel.segmentedControlItems) {
                
                let poiMapViewController = UIViewController.getViewController("POIMap", identifier: "POIMapViewController") as! POIMapViewController
                
                switch(item.element) {
                    
                    case .Scenic:
                        
                        poiMapViewController.poiMapViewModel = POIMapViewModel(searchPOIListCommand: queryPOIListScenicCommand)
                        
                        break
                        
                    case .Food:
                        
                        poiMapViewController.poiMapViewModel = POIMapViewModel(searchPOIListCommand: queryPOIListFoodCommand)
                        
                        break
                        
                    case .Shopping:
                        
                        poiMapViewController.poiMapViewModel = POIMapViewModel(searchPOIListCommand: queryPOIListShoppingCommand)
                        
                        break
                        
                    case .Hotel:
                        
                        poiMapViewController.poiMapViewModel = POIMapViewModel(searchPOIListCommand: queryPOIListHotelCommand)
                        
                        break
                        
                    case .Activity:
                        
                        poiMapViewController.poiMapViewModel = POIMapViewModel(searchPOIListCommand: queryPOIListActivityCommand)
                        
                        break
                    default:
                        
                        break
                }
                
                self.addChildViewController(poiMapViewController)
            }
            
            break;
        case .List: // 列表模式
            
            for item in enumerate(self.poiTypeViewModel.segmentedControlItems) {
                
                let poiListViewController = UIViewController.getViewController("POIList", identifier: "POIListViewController") as! POIListViewController
                
                switch(item.element) {
                    
                    case .Scenic:
                        
                        poiListViewController.poiListViewModel = POIListViewModel(refreshCommand: queryPOIListScenicCommand, loadmoreCommand: queryPOIListScenicCommand)
                        
                        break
                    
                    case .Food:
                        
                        poiListViewController.poiListViewModel = POIListViewModel(refreshCommand: queryPOIListFoodCommand, loadmoreCommand: queryPOIListFoodCommand)
                        
                        break
                    
                    case .Shopping:
                        
                        poiListViewController.poiListViewModel = POIListViewModel(refreshCommand: queryPOIListShoppingCommand, loadmoreCommand: queryPOIListShoppingCommand)
                        
                        break
                    
                    case .Hotel:
                        
                        poiListViewController.poiListViewModel = POIListViewModel(refreshCommand: queryPOIListHotelCommand, loadmoreCommand: queryPOIListHotelCommand)
                        
                        break
                    
                    case .Activity:
                        
                        poiListViewController.poiListViewModel = POIListViewModel(refreshCommand: queryPOIListActivityCommand, loadmoreCommand: queryPOIListActivityCommand)
                        
                        break
                    
                    default:
                        
                        break
                }
                
                self.addChildViewController(poiListViewController)
            }
            
            break;
            
        default:
            break;
        }
    }
    
    // MARK: - Set Up SwipeView
    
    private func setUpSwipeView() {
        
        swipeView.delegate = self
        swipeView.dataSource = self
        swipeView.bounces = true
    }
    
    // MARK: - SwipeViewDataSource
    
    func swipeView(swipeView: SwipeView!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView! {
        
//        var label:UILabel?
//        var resultView = view
//        
//        if resultView == nil {
//            
//            resultView = UIView(frame: self.swipeView.bounds)
//            resultView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
//            
//            label = UILabel(frame: self.swipeView.bounds)
//            label?.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
//            label?.backgroundColor = UIColor.clearColor()
//            label?.textAlignment = NSTextAlignment.Center
//            label?.font = label?.font.fontWithSize(50)
//            label?.tag = 1
//            
//            resultView.addSubview(label!)
//        } else {
//            
//            label = view.viewWithTag(1) as? UILabel
//        }
//        
//        let key     = items.keys[index]
//        let value   = items[key]
//        
//        label?.text = "\(key)"
//        resultView.backgroundColor = value
//        
//        return resultView
        
        let childViewController = self.childViewControllers[index] as! UIViewController
        
        return childViewController.view
    }
    
    func numberOfItemsInSwipeView(swipeView: SwipeView!) -> Int {
        
        return items.count
    }
    
    // MARK: - SwipeViewDelegate
    
    func swipeViewItemSize(swipeView: SwipeView!) -> CGSize {
        
        return self.swipeView.bounds.size
    }
    
    func swipeViewCurrentItemIndexDidChange(swipeView: SwipeView!) {
        
        self.segmentedControl.setSelectedSegmentIndex(UInt(swipeView.currentItemIndex), animated: true)
    }
}

