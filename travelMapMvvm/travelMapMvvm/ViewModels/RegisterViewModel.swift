//
//  RegisterViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/7.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa
import ReactiveViewModel

class RegisterViewModel: RVMViewModel {
   
    private let smsDataSourceProtocol = SMSDataSource.shareInstance()
    
    dynamic var countryAndAreaCode:CountryAndAreaCode!  // 国家名称、国家码
    dynamic var zonesArray = NSArray()                  // 支持的区号数组
    dynamic var errorMsg = ""                           // 错误提示信息
    
    var searchZonesArrayCommand:RACCommand!             // 查询支持的区号数组命令
    
    override init() {
        
        super.init()
        
        // 初始化查询命令
        searchZonesArrayCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            return self.smsDataSourceProtocol.queryZone()
        })
        
        // 处理错误
        searchZonesArrayCommand.errors.subscribeNextAs { (error:NSError!) -> () in
            
            self.errorMsg = error.localizedDescription
        }
        
        // 更新支持的区号数组
        searchZonesArrayCommand.executionSignals.switchToLatest().subscribeNextAs { (zonesArray:NSArray) -> () in
            
            self.zonesArray = zonesArray
        }
        
        // 激活后开始更新数据
        didBecomeActiveSignal.subscribeNext { (any:AnyObject!) -> Void in
            
            let tempSignal = self.smsDataSourceProtocol.queryZone()
            
            // 查询国家名称、国家码
            self.countryAndAreaCode = self.smsDataSourceProtocol.queryCountryAndAreaCode()
            
            // 查询支持的区号数组
            self.searchZonesArrayCommand.execute(nil)
        }
    }
}
