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
            
            self.pages = NSMutableArray(array: self.poiTypeViewModel.poiContainerViewModel.poiMapControllerDic.values.array)
            
            break;
        case .List: // 列表模式
            
            self.pages = NSMutableArray(array: self.poiTypeViewModel.poiContainerViewModel.poiListControllerDic.values.array)
            
            break;
            
        default:
            
            break;
        }
    }
}

