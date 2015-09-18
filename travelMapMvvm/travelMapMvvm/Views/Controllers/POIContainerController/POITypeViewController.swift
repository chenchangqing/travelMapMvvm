//
//  ViewController.swift
//  SSASideMenu+HMSegment+SwipeView
//
//  Created by green on 15/9/15.
//  Copyright (c) 2015年 chenchangqing. All rights reserved.
//

import UIKit
import ReactiveCocoa

class POITypeViewController: THSegmentedPager {
    
    // MARK: - View Model
    
    var poiTypeViewModel: POITypeViewModel!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    // MARK: - Set Up
    
    private func setUp() {
        
        setUpContentContainer()
    }
    
    // MARK: - Set Up contentContainer 
    
    private func setUpContentContainer() {
        
        switch (self.poiTypeViewModel.showPoiMode) {
            
        case .Map:  // 地图模式
            
            var pages = [POIMapViewController]()
            
            for item in enumerate(POITypeEnum.allValues) {
                
                let poiMapViewController = UIViewController.getViewController("POIMap", identifier: "POIMapViewController") as! POIMapViewController
                
                poiMapViewController.poiMapViewModel = POIMapViewModel(paramTuple: (self.poiTypeViewModel.poiContainerViewModel.paramTuple.queryType,item.element,self.poiTypeViewModel.poiContainerViewModel.paramTuple.param))
                
                poiMapViewController.title = item.element.rawValue
                
                pages.append(poiMapViewController)
            }
            
            self.pages = NSMutableArray(array: pages)
            
            break;
        case .List: // 列表模式
            
            var pages = [POIListViewController]()
            
            for item in enumerate(POITypeEnum.allValues) {
                
                let poiListViewController = UIViewController.getViewController("POIList", identifier: "POIListViewController") as! POIListViewController
                
                poiListViewController.poiListViewModel = POIMapViewModel(paramTuple: (self.poiTypeViewModel.poiContainerViewModel.paramTuple.queryType,item.element,self.poiTypeViewModel.poiContainerViewModel.paramTuple.param))
                
                poiListViewController.title = item.element.rawValue
                
                pages.append(poiListViewController)
            }
            
            self.pages = NSMutableArray(array: pages)
            
            break;
            
        default:
            
            break;
        }
    }
}

