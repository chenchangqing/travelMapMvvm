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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 停止定位
        if self.poiMapViewModel.locationManager.isRunning {
            
            self.showHUDMessage(kMsgStopLocation)
            self.poiMapViewModel.locationManager.stopUpdatingLocation()
        }
    }
    
    // MARK: - setup
    
    private func setup() {
        
        bindViewModel()
        setupMap()
        setupEvents()
        setupMessage()
        setupCommand()
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
            
            if btn.selected {
                
                self.showHUDMessage(kMsgStopLocation)
                self.poiMapViewModel.locationManager.stopUpdatingLocation()
                
                if let lastUserAnnotation = self.poiMapViewModel.lastUserAnnotation {
                    
                    self.mapView.removeAnnotation(lastUserAnnotation)
                }
                self.poiMapViewModel.lastCoordinate = nil
                
                for (key,value) in self.poiMapViewModel.distanceAnnotationDic {
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        
                        value.distanceL.alpha = 0
                    })
                }
            } else {
                
                self.showHUDMessage(kMsgStartLocation)
                
                // 开始定位
                self.poiMapViewModel.locationManager.startUpdatingLocationWithCompletionHandler(completionHandler: { (latitude, longitude, status, verboseMessage, error) -> () in
                    
                    if error != nil {
                        
                        self.poiMapViewModel.failureMsg = ErrorEnum.LocationError.rawValue
                    } else {
                        
                        
                        // 处理定位
                        let currentCoordinate = CLLocationCoordinate2DModel(latitude: latitude, longitude: longitude)
                        
                        // 查询位置
                        if let lastCoordinate = self.poiMapViewModel.lastCoordinate {
                            
                            if !currentCoordinate.isEqual(lastCoordinate) {
                                
                                self.poiMapViewModel.lastCoordinate = currentCoordinate
                                self.poiMapViewModel.updatingLocationPlacemarkCommand.execute(currentCoordinate)
                            }
                        } else {
                            
                            self.poiMapViewModel.lastCoordinate = currentCoordinate
                            self.poiMapViewModel.updatingLocationPlacemarkCommand.execute(currentCoordinate)
                        }
                    }
                })
            }
            
            btn.selected = !btn.selected
        }
    }
    
    /**
     * 地图设置
     */
    private func setupMap() {
        
        self.mapView.delegate = self
    }
    
    
    /**
     * 成功失败提示
     */
    private func setupMessage() {
        
        RACSignal.combineLatest([
            RACObserve(poiMapViewModel, "failureMsg"),
            RACObserve(poiMapViewModel, "successMsg")
        ]).subscribeNextAs { (tuple: RACTuple) -> () in
            
            let failureMsg  = tuple.first as! String
            let successMsg  = tuple.second as! String
            
            if !failureMsg.isEmpty {
                
                self.showHUDErrorMessage(failureMsg)
            }
            
            if !successMsg.isEmpty {
                
                self.showHUDMessage(successMsg)
            }
        }
    }

    /**
     * 命令设置
     */
    private func setupCommand() {
        
        poiMapViewModel.updatingLocationPlacemarkCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
                // 处理定位地址
                let locationPlaceMark = any as! CLPlacemark
                
//                println(locationPlaceMark)
                
                let currentUserAnnotation = MKPlacemark(placemark: locationPlaceMark)
                
                if let lastUserAnnotation = self.poiMapViewModel.lastUserAnnotation {
                    
                    self.mapView.removeAnnotation(lastUserAnnotation)
                }
                
                self.poiMapViewModel.lastUserAnnotation = currentUserAnnotation
                self.setupMapRegion(currentUserAnnotation)
                self.mapView.addAnnotation(currentUserAnnotation)
                self.mapView.selectAnnotation(currentUserAnnotation, animated: true)
                
                for (key,value) in self.poiMapViewModel.distanceAnnotationDic {
                    
                    let distanceStr = self.poiMapViewModel.caculateDistance(currentUserAnnotation.coordinate, toCoordinate: key.coordinate)
                    value.distanceL.text = distanceStr
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        
                        value.distanceL.alpha = 1
                    })
                }
            
            }, error: { (error:NSError!) -> Void in
                
                self.poiMapViewModel.failureMsg = error.localizedDescription
                
            }, completed: { () -> Void in
                    
                    
            })
        }
    }
}
