//
//  POIMapViewController.swift
//  travelMapMvvm
//
//  Created by green on 15/9/11.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import ReactiveCocoa

class POIMapViewController: UIViewController, THSegmentedPageViewControllerDelegate {
    
    // MARK: - UI
    
    @IBOutlet weak var locationBtn      : UIButton!     // 定位按钮
    @IBOutlet weak var scrollView       : GScrollView!  // POI水平显示控件
    @IBOutlet weak var mapView          : MKMapView!    // 地图
    
    // MARK: - View Model
    
    var poiMapViewModel: POIMapViewModel!
    
    // MARK: - reuseIdentifier
    
    let kBasicMapAnnotationView = "BasicMapAnnotationView"
    let kDistanceAnnotationView = "DistanceAnnotationView"
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        self.poiMapViewModel.active = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 停止定位
        if self.poiMapViewModel.locationManager.isRunning {
            
            self.showHUDMessage(kMsgStopLocation)
            self.poiMapViewModel.locationManager.stopUpdatingLocation()
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == kSegueFromPOIMapViewControllerToPOIDetailViewController {
            
            let poiDetailViewModel = POIDetailViewModel(poiModel: sender as! POIModel)
            let poiDetailViewController = segue.destinationViewController as! POIDetailViewController
            poiDetailViewController.poiDetailViewModel = poiDetailViewModel
        }
    }
    
    // MARK: - setup
    
    private func setup() {
        
        setUpCommand()
        bindViewModel()
        setupMap()
        setupEvents()
        setupMessage()
    }
    
    /**
     * 命令设置
     */
    private func setUpCommand() {
        
        poiMapViewModel.searchPOIListCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
                // 处理POI列表
                self.poiMapViewModel.poiList = any as! [POIModel]
                
            }, error: { (error:NSError!) -> Void in
                
                self.poiMapViewModel.failureMsg = error.localizedDescription
                
            }, completed: { () -> Void in
                
                //                println("completed")
            })
        }
        
        poiMapViewModel.updatingLocationPlacemarkCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
                // 处理定位地址
            self.poiMapViewModel.lastUserAnnotation = MKPlacemark(placemark: any as! CLPlacemark)
            
            }, error: { (error:NSError!) -> Void in
                
                self.poiMapViewModel.failureMsg = error.localizedDescription
                
            }, completed: { () -> Void in
                    
                    
            })
        }
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
        
        RACObserve(self, "poiMapViewModel.lastCoordinate").subscribeNext { (lastCoordinate:AnyObject?) -> () in
            
            if let lastCoordinate=lastCoordinate as? CLLocationCoordinate2DModel {
                
                // 查询位置信息
                self.poiMapViewModel.updatingLocationPlacemarkCommand.execute(lastCoordinate)
                // 显示距离
                self.showDistances(lastCoordinate.latitude, longitude: lastCoordinate.longitude)
            }
        }
        
        RACObserve(self, "poiMapViewModel.lastUserAnnotation").subscribeNext { (currentUserAnnotation:AnyObject?) -> () in
            
            // 更新标注
            self.updateLastUserAnnotation(currentUserAnnotation as? MKPlacemark)
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
                
                self.resetUserPositionInfo()    // 重置坐标及标注
                self.hideDistances()            // 隐藏距离
            } else {
                
                self.showHUDMessage(kMsgStartLocation)
                
                // 开始定位
                self.startUpdatingLocation()
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
            RACObserve(poiMapViewModel, "successMsg"),
            self.poiMapViewModel.searchPOIListCommand.executing
        ]).subscribeNextAs { (tuple: RACTuple) -> () in
            
            let failureMsg  = tuple.first as! String
            let successMsg  = tuple.second as! String
            
            let isLoading = tuple.third as! Bool
            
            if isLoading {
                
                self.showHUDIndicator()
            } else {
                
                if failureMsg.isEmpty && successMsg.isEmpty {
                    
                    self.hideHUD()
                }
            }
            
            if !failureMsg.isEmpty {
                
                self.showHUDErrorMessage(failureMsg)
            }
            
            if !successMsg.isEmpty {
                
                self.showHUDMessage(successMsg)
            }
        }
    }
    
    // MARK: - THSegmentedPageViewControllerDelegate
    
    func viewControllerTitle() -> String! {
        
        return self.title
    }
}
