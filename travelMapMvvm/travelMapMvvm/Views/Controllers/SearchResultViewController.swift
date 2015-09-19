//
//  SearchResultViewController.swift
//  travelMapMvvm
//
//  Created by green on 15/9/19.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import RBStoryboardLink

class SearchResultViewController: THSegmentedPager {
    
    // MARK: - View Model
    
    var searchResultViewModel = SearchResultViewModel()
    
    // MARK: - 搜索结果控制器
    
    var strategyListViewController : StrategyListViewController!
    var poiListViewController : POIListViewController!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    // MARK: - Set Up
    
    private func setUp() {
        
        strategyListViewController = UIViewController.getViewController("StrategyList", identifier: "StrategyListViewController")  as! StrategyListViewController
        strategyListViewController.title = "攻略"
        
        poiListViewController = UIViewController.getViewController("POIList", identifier: "POIListViewController") as! POIListViewController
        poiListViewController.title = "目的地"
        
        self.pages = NSMutableArray(array: [strategyListViewController,poiListViewController])
        
        RACObserve(self.searchResultViewModel, "keyword").ignore("").subscribeNextAs { (keyword:NSString) -> () in
            
            // 设置参数
            self.strategyListViewController.strategyListViewModel.paramTuple = (QueryTypeEnum.StrategyListByKeyword,self.searchResultViewModel.keyword)
            self.poiListViewController.poiListViewModel.paramTuple = (QueryTypeEnum.POIListByKeyword, poiType: nil, param: self.searchResultViewModel.keyword)
            
            // 查询
            self.strategyListViewController.strategyListViewModel.refreshCommand.execute(nil)
            self.poiListViewController.poiListViewModel.refreshCommand.execute(nil)
        }
    }

}
