//
//  POIMapViewController+Location.swift
//  travelMapMvvm
//
//  Created by green on 15/9/13.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation

extension POIMapViewController {
    
    
    // MARK: -
    
    /**
     * 开始定位
     */
    func startUpdatingLocation() {
        
        self.poiMapViewModel.locationManager.startUpdatingLocationWithCompletionHandler(completionHandler: { (latitude, longitude, status, verboseMessage, error) -> () in
            
            if error != nil {
                
                self.poiMapViewModel.failureMsg = ErrorEnum.LocationError.rawValue
            } else {
                
                self.updateLastCoordinate(latitude, longitude: longitude)
            }
        })
    }
    
    /**
    * 更新坐标
    */
    func updateLastCoordinate(latitude:Double, longitude:Double) {
        
        // 处理定位
        let currentCoordinate = CLLocationCoordinate2DModel(latitude: latitude, longitude: longitude)
        
        // 查询位置
        if let lastCoordinate = self.poiMapViewModel.lastCoordinate {
            
            if !currentCoordinate.isEqual(lastCoordinate) {
                
                self.poiMapViewModel.lastCoordinate = currentCoordinate
            }
        } else {
            
            self.poiMapViewModel.lastCoordinate = currentCoordinate
        }
    }
    
    /**
    * 更新用户位置标注
    */
    func updateLastUserAnnotation(currentUserAnnotation:MKPlacemark?) {
        
        // 先移除原来的标注
        for tuple in enumerate(self.mapView.annotations) {
            
            if let an = tuple.element as? MKPlacemark {
                
                self.mapView.removeAnnotation(an)
            }
        }
        
        if let currentUserAnnotation=currentUserAnnotation {
            
            self.setupMapRegion(currentUserAnnotation)
            self.mapView.addAnnotation(currentUserAnnotation)
            self.mapView.selectAnnotation(currentUserAnnotation, animated: true)
        }
    }
    
    /**
    * 隐藏距离
    */
    func hideDistances() {
        
        for (key,value) in self.poiMapViewModel.distanceAnnotationDic {
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                value.distanceL.alpha = 0
            })
        }
    }
    
    /**
    * 显示距离
    */
    func showDistances(latitude:Double, longitude:Double) {
        
        let currentUserCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        for (key,value) in self.poiMapViewModel.distanceAnnotationDic {
            
            let distanceStr = CaculateDistanceHelper.caculateDistance(currentUserCoordinate, toCoordinate: key.coordinate)
            value.distanceL.text = distanceStr.str
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                value.distanceL.alpha = 1
            })
        }
    }
    
    /**
    * 重置坐标及标注
    */
    func resetUserPositionInfo() {
        
        self.poiMapViewModel.lastUserAnnotation = nil
        self.poiMapViewModel.lastCoordinate = nil
    }
}