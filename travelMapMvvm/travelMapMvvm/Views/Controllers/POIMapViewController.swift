//
//  POIMapViewController.swift
//  travelMapMvvm
//
//  Created by green on 15/9/11.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import ReactiveCocoa

class POIMapViewController: UIViewController {
    
    // MARK: - UI
    
    @IBOutlet weak var locationBtn      : UIButton!     // 定位按钮
    @IBOutlet weak var scrollView       : GScrollView!  // POI水平显示控件
    @IBOutlet weak var mapView          : MKMapView!    // 地图
    
    // MARK: - View Model
    
    var poiMapViewModel: POIMapViewModel = POIMapViewModel()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - setup
    
    private func setup() {
        
        bindView()
        setupEvents()
        setupMap()
    }
    
    /**
     * 绑定view model
     */
    private func bindView() {
        
        RACObserve(self, "poiMapViewModel.poiList").subscribeNextAs { (poiList:[POIModel]!) -> () in
            
            // 更新POI水平显示控件
            self.scrollView.dataSource = poiList
            
            // 更新地图
        }
    }
    
    /**
     * 事件设置
     */
    private func setupEvents() {
        
        // POI水平显示控件
        self.scrollView.selectFunc = { index in
            
        }
        
        self.scrollView.unselectFunc = { index in
            
        }
        
        // 点击定位按钮
        locationBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNextAs { (btn:UIButton!) -> () in
            
        }
    }
    
    /**
     * 地图设置
     */
    private func setupMap() {
        
    }

}
