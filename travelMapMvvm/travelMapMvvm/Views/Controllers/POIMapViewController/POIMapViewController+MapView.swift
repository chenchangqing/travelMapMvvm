//
//  POIMapViewController+MapView.swift
//  travelMapMvvm
//
//  Created by green on 15/9/12.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import MapKit

extension POIMapViewController: MKMapViewDelegate {
    
    // MARK: - 地图区域设置
    
    /**
     * 地图区域设置
     */
    func setupMapRegion(annotation :MKAnnotation) {
        
        let latDelta = 0.05
        let longDelta = 0.05
        
        let currentLocationSpan: MKCoordinateSpan   = MKCoordinateSpanMake(latDelta, longDelta)
        let currentRegion: MKCoordinateRegion       = MKCoordinateRegionMake(annotation.coordinate, currentLocationSpan)
        self.mapView.setRegion(currentRegion, animated: false)
        
    }
    
    // MARK: - GET Annotation
    
    /**
     * basicAnnotationView
     */
    func getBasicAnnotationView(basicMapAnnotation:BasicMapAnnotation) -> BasicMapAnnotationView {
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(kBasicMapAnnotationView) as? BasicMapAnnotationView
        if annotationView == nil {
            
            annotationView = BasicMapAnnotationView(annotation: basicMapAnnotation, reuseIdentifier: kBasicMapAnnotationView)
        }
        
        let text                            = basicMapAnnotation.index + 1
        annotationView!.indexL.text         = "\(text)"
        annotationView?.canShowCallout      = true
        annotationView?.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIView
        
        return annotationView!
    }
    
    /**
     * distanceAnnotationView
     */
    func getDistanceAnnotationView(distanceAnnotation:DistanceAnnotation) -> DistanceAnnotationView {
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(kDistanceAnnotationView) as? DistanceAnnotationView
        if annotationView == nil {
            
            annotationView = DistanceAnnotationView(annotation: distanceAnnotation, reuseIdentifier: kDistanceAnnotationView)
        }
        return annotationView!
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation is MKUserLocation {
            
            return nil
        }
        
        if let annotation = annotation as? BasicMapAnnotation {
            
            return self.poiMapViewModel.basicMapAnnotationDic[annotation]
        }
        
        if let annotation = annotation as? DistanceAnnotation {
            
            return self.poiMapViewModel.distanceAnnotationDic[annotation]
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let annotationView  = annotationView as! BasicMapAnnotationView
        let annotation      = annotationView.annotation as! BasicMapAnnotation
        let poi             = self.poiMapViewModel.poiList[annotation.index]
        
        self.performSegueWithIdentifier(kSegueFromPOIMapViewControllerToPOIDetailViewController, sender: poi)
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        if let basicMapAnnotation = view.annotation as? BasicMapAnnotation {
            
            self.poiMapViewModel.selectedBasicMapAnnotation = basicMapAnnotation
            self.scrollView.focus(basicMapAnnotation.index)
        }
    }
    
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        
        // POI水平显示控件 默认选中
        
        if self.poiMapViewModel.selectedBasicMapAnnotation == nil {
            
            if 0 < self.poiMapViewModel.basicMapAnnotationDic.count {
                
                self.mapView.selectAnnotation(self.poiMapViewModel.basicMapAnnotationDic.keys[0], animated: true)
                // 地图区域设置
                self.setupMapRegion(self.poiMapViewModel.basicMapAnnotationDic.keys[0])
            }
        } else {
            
            self.mapView.selectAnnotation(self.poiMapViewModel.selectedBasicMapAnnotation, animated: true)
            // 地图区域设置
            self.setupMapRegion(self.poiMapViewModel.selectedBasicMapAnnotation)
        }
        
    }
}