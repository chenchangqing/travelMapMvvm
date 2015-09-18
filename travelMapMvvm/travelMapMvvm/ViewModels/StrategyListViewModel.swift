//
//  StrategyListViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/18.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveViewModel

class StrategyListViewModel: RVMViewModel {
    
    // MARK: - 查询参数元组
    
    var paramTuple: (queryType:QueryTypeEnum,param:String)
    
    // MARK: - 提示信息
    
    dynamic var failureMsg  : String = ""   // 操作失败提示
    dynamic var successMsg  : String = ""   // 操作失败提示
    
    // MARK: - Data
    
    dynamic var strategyList = [StrategyModel]()
    
    // MARK: - Commands
    
    var refreshCommand: RACCommand!
    var loadmoreCommand: RACCommand!
    
    private let strategyModelDataSourceProtocol = JSONStrategyModelDataSource.shareInstance()
    
    // MARK: - Init
    
    init(paramTuple: (queryType:QueryTypeEnum,param:String) = (.StrategyListBySystem,"")) {
        
        self.paramTuple = paramTuple
        
        super.init()
        
        setUpCommands()
    }
    
    // MARK: - Set Up Commands
    
    private func setUpCommands() {
     
        switch(self.paramTuple.queryType) {
            
            // 系统推荐攻略
            case .StrategyListBySystem:
                
                self.refreshCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                    
                    return self.strategyModelDataSourceProtocol.queryStrategyListBySystem(StrategyThemeEnum.allValues, strategyMonthArray: MonthEnum.allValues, strategyTypeArray: StrategyTypeEnum.allValues, order: StrategyOrderEnum.Default, rowCount: 5, startId: nil).materialize()
                })
                
                self.loadmoreCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                    
                    return self.strategyModelDataSourceProtocol.queryStrategyListBySystem(StrategyThemeEnum.allValues, strategyMonthArray: MonthEnum.allValues, strategyTypeArray: StrategyTypeEnum.allValues, order: StrategyOrderEnum.Default, rowCount: 5, startId: nil).materialize()
                })
                
                break;
            
            // 关键字攻略
            case .StrategyListByKeyword:
                
                self.refreshCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                    
                    return self.strategyModelDataSourceProtocol.queryStrategyListByKeyword(self.paramTuple.param, order: StrategyOrderEnum.Default, rowCount: 5, startId: nil).materialize()
                })
                
                self.loadmoreCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                    
                    return self.strategyModelDataSourceProtocol.queryStrategyListByKeyword(self.paramTuple.param, order: StrategyOrderEnum.Default, rowCount: 5, startId: nil).materialize()
                })
            
                break;
            
            // 已收藏攻略
            case .StrategyListByUserId:
                
                self.refreshCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                    
                    return self.strategyModelDataSourceProtocol.queryStrategyListByUserId(self.paramTuple.param, order: StrategyOrderEnum.Default, rowCount: 5, startId: nil).materialize()
                })
                
                self.loadmoreCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
                    
                    return self.strategyModelDataSourceProtocol.queryStrategyListByUserId(self.paramTuple.param, order: StrategyOrderEnum.Default, rowCount: 5, startId: nil).materialize()
                })
            
                break;
            
            default:
                
                break;
            
        }
    }

}
