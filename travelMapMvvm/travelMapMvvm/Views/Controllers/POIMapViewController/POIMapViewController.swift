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
    
    // MARK: - reuseIdentifier
    let kBasicMapAnnotationView = "BasicMapAnnotationView"
    let kDistanceAnnotationView = "DistanceAnnotationView"
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - setup
    
    private func setup() {
        
        bindViewModel()
        setupMap()
        setupEvents()
    }
    
    /**
     * 绑定view model
     */
    private func bindViewModel() {
        
        RACObserve(self, "poiMapViewModel.poiList").subscribeNextAs { (poiList:[POIModel]!) -> () in
            
            // 更新POI水平显示控件
            self.scrollView.dataSource = poiList
            
            // 更新地图
            // 删除标注
            self.mapView.removeAnnotations(self.poiMapViewModel.basicMapAnnotationDic.keys)
            self.mapView.removeAnnotations(self.poiMapViewModel.distanceAnnotationDic.keys)
            
            // 组织标注dic
            for poiTuple in enumerate(poiList) {
                
                let annotationTuple = self.poiMapViewModel.getAnnotationTuple(poiTuple.element, i: poiTuple.index)
                
                if let basicMapAnnotation=annotationTuple.basicMapAnnotation {
                    
                    self.poiMapViewModel.basicMapAnnotationDic[basicMapAnnotation] = self.getBasicAnnotationView(basicMapAnnotation)
                    
                    // 地图区域设置
                    if poiTuple.index == 0 {
                        
                        self.setupMapRegion(basicMapAnnotation)
                    }
                    
                    // callout
                    basicMapAnnotation.title = poiTuple.element.poiName
                    basicMapAnnotation.subtitle = poiTuple.element.address
                }
                
                if let distanceAnnotation=annotationTuple.distanceAnnotation {
                    
                    self.poiMapViewModel.distanceAnnotationDic[distanceAnnotation] = self.getDistanceAnnotationView(distanceAnnotation)
                }
            }
            
            // 增加标注
            self.mapView.addAnnotations(self.poiMapViewModel.basicMapAnnotationDic.keys)
            self.mapView.addAnnotations(self.poiMapViewModel.distanceAnnotationDic.keys)
        }
    }
    
    /**
     * 事件设置
     */
    private func setupEvents() {
        
        // POI水平显示控件
        self.scrollView.selectFunc = { index in
            
            if index < self.poiMapViewModel.basicMapAnnotationDic.count {
                
                self.mapView.selectAnnotation(self.poiMapViewModel.basicMapAnnotationDic.keys[index], animated: true)
            }
        }
        
        self.scrollView.unselectFunc = { index in
            
            if index < self.poiMapViewModel.basicMapAnnotationDic.count {
                
                self.mapView.deselectAnnotation(self.poiMapViewModel.basicMapAnnotationDic.keys[index], animated: true)
            }
        }
        
        // 点击定位按钮
        locationBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNextAs { (btn:UIButton!) -> () in
            
        }
    }
    
    /**
     * 地图设置
     */
    private func setupMap() {
        
        self.mapView.delegate = self
    }

}
