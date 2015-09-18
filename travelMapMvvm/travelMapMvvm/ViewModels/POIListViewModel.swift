//
//  POIListViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/16.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveViewModel

class POIListViewModel: RVMViewModel {
    
    // MARK: - 查询参数元组
    
    var paramTuple: (queryType:QueryTypeEnum, poiType:POITypeEnum?, param:String)
    
    // MARK: - 提示信息
    
    dynamic var failureMsg  : String = ""   // 操作失败提示
    dynamic var successMsg  : String = ""   // 操作失败提示
    
    // MARK: - POI列表
    
    dynamic var poiList = [POIModel]()
    
    // MARK: - Commands
    
    var refreshCommand: RACCommand!
    var loadmoreCommand: RACCommand!
    
    private let poiModelDataSourceProtocol = JSONPOIModelDataSource.shareInstance()
    
    // MARK: - Init
    
    init(paramTuple:(queryType:QueryTypeEnum, poiType:POITypeEnum?, param:String)) {
        
        self.paramTuple = paramTuple
        
        super.init()
        
        setUpCommands()
    }
    
    // MARK: - Set Up Commands
    
    private func setUpCommands() {
        
        switch (self.paramTuple.queryType)
        {
            case .POIListByCenterPOIId:
                
                self.refreshCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                    
                    return self.poiModelDataSourceProtocol.queryPOIListByCenterPOIId(self.paramTuple.param, poiType: self.paramTuple.poiType, rows: 5, startId: nil).materialize()
                })
                
                self.loadmoreCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                    
                    return self.poiModelDataSourceProtocol.queryPOIListByCenterPOIId(self.paramTuple.param, poiType: self.paramTuple.poiType, rows: 5, startId: nil).materialize()
                })
                
                break;
                
            case .POIListByCityId:
                
                self.refreshCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                    
                    return self.poiModelDataSourceProtocol.queryPOIListByCityId(self.paramTuple.param, poiType: self.paramTuple.poiType, rows: 5, startId: nil).materialize()
                })
                
                self.loadmoreCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                    
                    return self.poiModelDataSourceProtocol.queryPOIListByCityId(self.paramTuple.param, poiType: self.paramTuple.poiType, rows: 5, startId: nil).materialize()
                })
                
                break;
            
            case .POIListByKeyword:
                
                self.refreshCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                    
                    return self.poiModelDataSourceProtocol.queryPOIListByKeyword(self.paramTuple.param, poiType: self.paramTuple.poiType, rows: 5, startId: nil).materialize()
                })
                
                self.loadmoreCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                    
                    return self.poiModelDataSourceProtocol.queryPOIListByKeyword(self.paramTuple.param, poiType: self.paramTuple.poiType, rows: 5, startId: nil).materialize()
                })
                
                break;
                
            case .POIListByStrategyId:
                
                self.refreshCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                    
                    return self.poiModelDataSourceProtocol.queryPOIListByStrategyId(self.paramTuple.param, poiType: self.paramTuple.poiType, rows: 5, startId: nil).materialize()
                })
                
                self.loadmoreCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                    
                    return self.poiModelDataSourceProtocol.queryPOIListByStrategyId(self.paramTuple.param, poiType: self.paramTuple.poiType, rows: 5, startId: nil).materialize()
                })
                
                break;
                
            case .POIListByUserId:
                
                self.refreshCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                    
                    return self.poiModelDataSourceProtocol.queryPOIListByUserId(self.paramTuple.param, poiType: self.paramTuple.poiType, rows: 5, startId: nil).materialize()
                })
                
                self.loadmoreCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                    
                    return self.poiModelDataSourceProtocol.queryPOIListByUserId(self.paramTuple.param, poiType: self.paramTuple.poiType, rows: 5, startId: nil).materialize()
                })
                
                break;
            
            default:
                
                break;
        }
    }
}