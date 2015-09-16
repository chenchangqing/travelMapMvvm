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
    
    // MARK: - Map POI 控制器字典
    
    var poiMapControllerDic = [POITypeEnum:POIMapViewController]()
    
    // MARK: - List POI 控制器字典
    
    var poiListControllerDic = [POITypeEnum:POIListViewController]()
    
    // MARK: - Init
    
    init(paramTuple: (queryType:QueryTypeEnum,param:String)) {
        
        self.paramTuple = paramTuple
        
        super.init()
        
        setUpCommands()
        setUpPOIListControllerDic()
        setUpPOIMapControllerDic()
        bindDataBetweenMapPOIViewControllerAndListPOIViewController()
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
    
    // MARK: - Set Up Map/List Controllers
    
    /**
     * Map POI 控制器字典
     */
    private func setUpPOIMapControllerDic() {
        
        for item in enumerate(POITypeEnum.allValues) {
            
            let poiMapViewController = UIViewController.getViewController("POIMap", identifier: "POIMapViewController") as! POIMapViewController
            
            // Map数据来源是绑定列表数据，这里不用查询
            let emptyCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                
                return RACSignal.empty().materialize()
            })
            
            switch(item.element) {
                
            case .Scenic:
                
                poiMapViewController.poiMapViewModel = POIMapViewModel(searchPOIListCommand: queryPOIListScenicCommand)
                poiMapViewController.title = POITypeEnum.Scenic.rawValue
                
                poiMapControllerDic[.Scenic] = poiMapViewController
                
                break
                
            case .Food:
                
                poiMapViewController.poiMapViewModel = POIMapViewModel(searchPOIListCommand: queryPOIListFoodCommand)
                poiMapViewController.title = POITypeEnum.Food.rawValue
                
                poiMapControllerDic[.Food] = poiMapViewController
                
                break
                
            case .Shopping:
                
                poiMapViewController.poiMapViewModel = POIMapViewModel(searchPOIListCommand: queryPOIListShoppingCommand)
                poiMapViewController.title = POITypeEnum.Shopping.rawValue
                
                poiMapControllerDic[.Shopping] = poiMapViewController
                
                break
                
            case .Hotel:
                
                poiMapViewController.poiMapViewModel = POIMapViewModel(searchPOIListCommand: queryPOIListHotelCommand)
                poiMapViewController.title = POITypeEnum.Hotel.rawValue
                
                poiMapControllerDic[.Hotel] = poiMapViewController
                
                break
                
            case .Activity:
                
                poiMapViewController.poiMapViewModel = POIMapViewModel(searchPOIListCommand: queryPOIListActivityCommand)
                poiMapViewController.title = POITypeEnum.Activity.rawValue
                
                poiMapControllerDic[.Activity] = poiMapViewController
                
                break
            default:
                
                break
            }
        }
    }
    
    /**
     * List POI 控制器字典
     */
    private func setUpPOIListControllerDic() {
        
        for item in enumerate(POITypeEnum.allValues) {
            
            let poiListViewController = UIViewController.getViewController("POIList", identifier: "POIListViewController") as! POIListViewController
            
            switch(item.element) {
                
            case .Scenic:
                
                poiListViewController.poiListViewModel = POIListViewModel(refreshCommand: queryPOIListScenicCommand, loadmoreCommand: queryPOIListScenicCommand)
                poiListViewController.title = POITypeEnum.Scenic.rawValue
                
                poiListControllerDic[.Scenic] = poiListViewController
                
                break
                
            case .Food:
                
                poiListViewController.poiListViewModel = POIListViewModel(refreshCommand: queryPOIListFoodCommand, loadmoreCommand: queryPOIListFoodCommand)
                poiListViewController.title = POITypeEnum.Food.rawValue
                
                poiListControllerDic[.Food] = poiListViewController
                
                break
                
            case .Shopping:
                
                poiListViewController.poiListViewModel = POIListViewModel(refreshCommand: queryPOIListShoppingCommand, loadmoreCommand: queryPOIListShoppingCommand)
                poiListViewController.title = POITypeEnum.Shopping.rawValue
                
                poiListControllerDic[.Shopping] = poiListViewController
                
                break
                
            case .Hotel:
                
                poiListViewController.poiListViewModel = POIListViewModel(refreshCommand: queryPOIListHotelCommand, loadmoreCommand: queryPOIListHotelCommand)
                poiListViewController.title = POITypeEnum.Hotel.rawValue
                
                poiListControllerDic[.Hotel] = poiListViewController
                
                break
                
            case .Activity:
                
                poiListViewController.poiListViewModel = POIListViewModel(refreshCommand: queryPOIListActivityCommand, loadmoreCommand: queryPOIListActivityCommand)
                poiListViewController.title = POITypeEnum.Activity.rawValue
                
                poiListControllerDic[.Activity] = poiListViewController
                
                break
                
            default:
                
                break
            }
        }
    }
    
    // MARK: - MapPOI控制器数据 与 ListPOI控制器数据 保持一致
    
    private func bindDataBetweenMapPOIViewControllerAndListPOIViewController() {
        
        for item in enumerate(POITypeEnum.allValues) {
            
            let poiMapViewController    = poiMapControllerDic[item.element]!
            let poiListViewController   = poiListControllerDic[item.element]!
            
//            RACObserve(poiListViewController.poiListViewModel, "poiList") ~> RAC(poiMapViewController.poiMapViewModel,"poiList")
//            RACObserve(poiMapViewController.poiMapViewModel, "poiList") ~> RAC(poiListViewController.poiListViewModel,"poiList")
        }
    }
}
