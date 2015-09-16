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
        
        let queryPOIListScenicCommand   = self.poiTypeViewModel.poiContainerViewModel.queryPOIListScenicCommand
        let queryPOIListFoodCommand     = self.poiTypeViewModel.poiContainerViewModel.queryPOIListFoodCommand
        let queryPOIListShoppingCommand = self.poiTypeViewModel.poiContainerViewModel.queryPOIListShoppingCommand
        let queryPOIListHotelCommand    = self.poiTypeViewModel.poiContainerViewModel.queryPOIListHotelCommand
        let queryPOIListActivityCommand = self.poiTypeViewModel.poiContainerViewModel.queryPOIListActivityCommand
        
        var pages = [UIViewController]()
        
        switch (self.poiTypeViewModel.showPoiMode) {
            
        case .Map:  // 地图模式
            
            for item in enumerate(self.poiTypeViewModel.segmentedControlItems) {
                
                let poiMapViewController = UIViewController.getViewController("POIMap", identifier: "POIMapViewController") as! POIMapViewController
                pages.append(poiMapViewController)
                
                switch(item.element) {
                    
                case .Scenic:
                    
//                    let tempC = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
//                        
//                        return RACSignal.empty().materialize()
//                    })
//                    poiMapViewController.poiMapViewModel = POIMapViewModel(searchPOIListCommand: tempC)
                    
                    poiMapViewController.poiMapViewModel = POIMapViewModel(searchPOIListCommand: queryPOIListScenicCommand)
                    poiMapViewController.title = POITypeEnum.Scenic.rawValue
                    
                    break
                    
                case .Food:
                    
                    poiMapViewController.poiMapViewModel = POIMapViewModel(searchPOIListCommand: queryPOIListFoodCommand)
                    poiMapViewController.title = POITypeEnum.Food.rawValue
                    
                    break
                    
                case .Shopping:
                    
                    poiMapViewController.poiMapViewModel = POIMapViewModel(searchPOIListCommand: queryPOIListShoppingCommand)
                    poiMapViewController.title = POITypeEnum.Shopping.rawValue
                    
                    break
                    
                case .Hotel:
                    
                    poiMapViewController.poiMapViewModel = POIMapViewModel(searchPOIListCommand: queryPOIListHotelCommand)
                    poiMapViewController.title = POITypeEnum.Hotel.rawValue
                    
                    break
                    
                case .Activity:
                    
                    poiMapViewController.poiMapViewModel = POIMapViewModel(searchPOIListCommand: queryPOIListActivityCommand)
                    poiMapViewController.title = POITypeEnum.Activity.rawValue
                    
                    break
                default:
                    
                    break
                }
            }
            
            break;
        case .List: // 列表模式
            
            for item in enumerate(self.poiTypeViewModel.segmentedControlItems) {
                
                let poiListViewController = UIViewController.getViewController("POIList", identifier: "POIListViewController") as! POIListViewController
                pages.append(poiListViewController)
                
                switch(item.element) {
                    
                case .Scenic:
                    
                    poiListViewController.poiListViewModel = POIListViewModel(refreshCommand: queryPOIListScenicCommand, loadmoreCommand: queryPOIListScenicCommand)
                    poiListViewController.title = POITypeEnum.Scenic.rawValue
                    
                    break
                    
                case .Food:
                    
                    poiListViewController.poiListViewModel = POIListViewModel(refreshCommand: queryPOIListFoodCommand, loadmoreCommand: queryPOIListFoodCommand)
                    poiListViewController.title = POITypeEnum.Food.rawValue
                    
                    break
                    
                case .Shopping:
                    
                    poiListViewController.poiListViewModel = POIListViewModel(refreshCommand: queryPOIListShoppingCommand, loadmoreCommand: queryPOIListShoppingCommand)
                    poiListViewController.title = POITypeEnum.Shopping.rawValue
                    
                    break
                    
                case .Hotel:
                    
                    poiListViewController.poiListViewModel = POIListViewModel(refreshCommand: queryPOIListHotelCommand, loadmoreCommand: queryPOIListHotelCommand)
                    poiListViewController.title = POITypeEnum.Hotel.rawValue
                    
                    break
                    
                case .Activity:
                    
                    poiListViewController.poiListViewModel = POIListViewModel(refreshCommand: queryPOIListActivityCommand, loadmoreCommand: queryPOIListActivityCommand)
                    poiListViewController.title = POITypeEnum.Activity.rawValue
                    
                    break
                    
                default:
                    
                    break
                }
            }
            
            break;
            
        default:
            break;
        }
        self.pages = NSMutableArray(array: pages)
    }
}

