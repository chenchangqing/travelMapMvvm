//
//  POIContainerViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/16.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveViewModel

class POIContainerViewModel: RVMViewModel {
    
    // MARK: - 查询参数元组
    
    var paramTuple: (queryType:QueryTypeEnum,param:String)
    
    // MARK: - Query POI List Commands
    
    var queryPOIListScenicCommand   :RACCommand!    // 景点
    var queryPOIListFoodCommand     :RACCommand!    // 餐饮
    var queryPOIListShoppingCommand :RACCommand!    // 购物
    var queryPOIListHotelCommand    :RACCommand!    // 酒店
    var queryPOIListActivityCommand :RACCommand!    // 活动
    
    private let poiModelDataSourceProtocol = JSONPOIModelDataSource.shareInstance()
    
    // MARK: - Init
    
    init(paramTuple: (queryType:QueryTypeEnum,param:String)) {
        
        self.paramTuple = paramTuple
        
        super.init()
        
        setUpCommands()
    }
    
    // MARK: - Set Up Commands
    
    private func setUpCommands() {
        switch (paramTuple.queryType) {
            
        case QueryTypeEnum.POIListByCityId:         // 城市POI
            
            self.queryPOIListScenicCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                
                return self.poiModelDataSourceProtocol.queryPOIListByCityId(self.paramTuple.param, poiType: POITypeEnum.Scenic, rows: 5, startId: (any as? String)).materialize()
            })
            
            self.queryPOIListFoodCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                
                return self.poiModelDataSourceProtocol.queryPOIListByCityId(self.paramTuple.param, poiType: POITypeEnum.Food, rows: 5, startId: (any as? String)).materialize()
            })
            
            self.queryPOIListShoppingCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                
                return self.poiModelDataSourceProtocol.queryPOIListByCityId(self.paramTuple.param, poiType: POITypeEnum.Shopping, rows: 5, startId: (any as? String)).materialize()
            })
            
            self.queryPOIListHotelCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                
                return self.poiModelDataSourceProtocol.queryPOIListByCityId(self.paramTuple.param, poiType: POITypeEnum.Hotel, rows: 5, startId: (any as? String)).materialize()
            })
            
            self.queryPOIListActivityCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                
                return self.poiModelDataSourceProtocol.queryPOIListByCityId(self.paramTuple.param, poiType: POITypeEnum.Activity, rows: 5, startId: (any as? String)).materialize()
            })
            
            break;
        case QueryTypeEnum.POIListByUserId:         // 已收藏POI
            
            self.queryPOIListScenicCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                
                return self.poiModelDataSourceProtocol.queryPOIListByUserId(self.paramTuple.param, poiType: POITypeEnum.Scenic, rows: 5, startId: (any as? String)).materialize()
            })
            
            self.queryPOIListFoodCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                
                return self.poiModelDataSourceProtocol.queryPOIListByUserId(self.paramTuple.param, poiType: POITypeEnum.Food, rows: 5, startId: (any as? String)).materialize()
            })
            
            self.queryPOIListShoppingCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                
                return self.poiModelDataSourceProtocol.queryPOIListByUserId(self.paramTuple.param, poiType: POITypeEnum.Shopping, rows: 5, startId: (any as? String)).materialize()
            })
            
            self.queryPOIListHotelCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                
                return self.poiModelDataSourceProtocol.queryPOIListByUserId(self.paramTuple.param, poiType: POITypeEnum.Hotel, rows: 5, startId: (any as? String)).materialize()
            })
            
            self.queryPOIListActivityCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                
                return self.poiModelDataSourceProtocol.queryPOIListByUserId(self.paramTuple.param, poiType: POITypeEnum.Activity, rows: 5, startId: (any as? String)).materialize()
            })
            
            break;
        case QueryTypeEnum.POIListByCenterPOIId:    // 某个POI周边POI
            
            self.queryPOIListScenicCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                
                return self.poiModelDataSourceProtocol.queryPOIListByCenterPOIId(self.paramTuple.param, poiType: POITypeEnum.Scenic, rows: 5, startId: (any as? String)).materialize()
            })
            
            self.queryPOIListFoodCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                
                return self.poiModelDataSourceProtocol.queryPOIListByCenterPOIId(self.paramTuple.param, poiType: POITypeEnum.Food, rows: 5, startId: (any as? String)).materialize()
            })
            
            self.queryPOIListShoppingCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                
                return self.poiModelDataSourceProtocol.queryPOIListByCenterPOIId(self.paramTuple.param, poiType: POITypeEnum.Shopping, rows: 5, startId: (any as? String)).materialize()
            })
            
            self.queryPOIListHotelCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                
                return self.poiModelDataSourceProtocol.queryPOIListByCenterPOIId(self.paramTuple.param, poiType: POITypeEnum.Hotel, rows: 5, startId: (any as? String)).materialize()
            })
            
            self.queryPOIListActivityCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                
                return self.poiModelDataSourceProtocol.queryPOIListByCenterPOIId(self.paramTuple.param, poiType: POITypeEnum.Activity, rows: 5, startId: (any as? String)).materialize()
            })
            
            break;

        default:
            break;
        }
        
    }
}
