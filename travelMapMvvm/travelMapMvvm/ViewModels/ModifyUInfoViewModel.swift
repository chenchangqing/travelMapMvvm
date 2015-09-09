//
//  ModifyUInfoViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/9.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa
import ReactiveViewModel

class ModifyUInfoViewModel: RVMViewModel {
    
    dynamic var failureMsg: String = ""     // 操作失败提示
    dynamic var successMsg: String = ""     // 操作失败提示
    
    var leftViewModel: LeftViewModel!   // 侧边栏数据
    
    // MARK: -
    
    init(leftViewModel:LeftViewModel) {
        super.init()
        
        // 侧边栏数据
        self.leftViewModel = leftViewModel
    }
}
