//
//  POIMapViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/11.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveViewModel
import ReactiveCocoa

class POIMapViewModel: RVMViewModel {
   
    dynamic var poiList = [POIModel]()  // POI列表
    
    // MARK: - 标注
    
    var basicMapAnnotationDic = [BasicMapAnnotation:BasicMapAnnotationView]()
    var distanceAnnotationDic = [DistanceAnnotation:DistanceAnnotationView]()
    
    override init() {
        super.init()
    }
    
    /**
     * 获得标注数组元组
     */
    func getAnnotationTuple(poiModel:POIModel, i:Int) -> (basicMapAnnotation:BasicMapAnnotation?,distanceAnnotation:DistanceAnnotation?) {
        
        var basicAnnotation     : BasicMapAnnotation?
        var distanceAnnotation  : DistanceAnnotation?
        
        var latitude    : CLLocationDegrees?
        var longitude   : CLLocationDegrees?
        
        if poiModel.latitude != nil && poiModel.latitude != ""
        {
            latitude = (poiModel.latitude! as NSString).doubleValue
        }
        
        if poiModel.longitude != nil && poiModel.longitude != ""
        {
            longitude = (poiModel.longitude! as NSString).doubleValue
        }
        
        if latitude != nil && longitude != nil
        {
            basicAnnotation     = BasicMapAnnotation(latitude: latitude!, longitude: longitude!, index: i)
            
            distanceAnnotation  = DistanceAnnotation(latitude: latitude!, longitude: longitude!, distance: "-")
        }
        
        return (basicAnnotation,distanceAnnotation)
    }
}
