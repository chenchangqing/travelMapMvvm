//
//  POIMapViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/11.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveViewModel
import ReactiveCocoa
import MapKit

class POIMapViewModel: RVMViewModel {
    
    // MARK: - 提示信息
    
    dynamic var failureMsg  : String = ""   // 操作失败提示
    dynamic var successMsg  : String = ""   // 操作失败提示
    
    // MARK: - POI列表
    
    dynamic var poiList = [POIModel]()
    
    // MARK: - 标注
    
    var basicMapAnnotationDic = OrderedDictionary<BasicMapAnnotation,BasicMapAnnotationView>()
    var distanceAnnotationDic = OrderedDictionary<DistanceAnnotation,DistanceAnnotationView>()
    
    var selectedBasicMapAnnotation : BasicMapAnnotation!
    
    // MARK: - 定位类
    
    let locationManager = LocationManager.sharedInstance
    
    dynamic var lastCoordinate: CLLocationCoordinate2DModel?
    dynamic var lastUserAnnotation: MKAnnotation?
    
    // MARK: - Commands
    
    var updatingLocationPlacemarkCommand: RACCommand!
    
    
    override init() {
        super.init()
        
        locationManager.showVerboseMessage = true
        locationManager.autoUpdate = true // 标准定位
        
        updatingLocationPlacemarkCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            if let coordinateModel = any as? CLLocationCoordinate2DModel {
                
                return RACSignal.createSignal({ (subscriber:RACSubscriber!) -> RACDisposable! in
                    
                    self.locationManager.reverseGeocodeLocationWithLatLon(latitude: coordinateModel.latitude, longitude: coordinateModel.longitude) { (reverseGecodeInfo, placemark, error) -> Void in
                        
                        if error != nil {
                            
                            subscriber.sendError(ErrorEnum.GeocodeLocationError.error)
                        } else {
                            
                            subscriber.sendNext(placemark)
                            subscriber.sendCompleted()
                        }
                    }
                    
                    return nil
                }).materialize()
            } else {
                
                return RACSignal.empty()
            }
        })
        
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
