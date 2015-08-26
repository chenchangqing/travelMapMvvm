//
//  IndexViewController.swift
//  travelMapMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit

/**
 * 首页控制器
 */
class IndexViewController: UITableViewController {
    
    private var indexViewModel: IndexViewModelProtocol = IndexViewModel()

    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    deinit {
    
        // 注销KVO
        indexViewModel.queryIndexPageStrategyListBusiness.businessModel.removeObserver(self, forKeyPath: kData)
    }
    
    // MARK: - setup
    
    private func setup() {
     
        // 注册KVO
        indexViewModel.queryIndexPageStrategyListBusiness.businessModel.addObserver(self, forKeyPath: kData, options: NSKeyValueObservingOptions.New, context: nil)
        
        // 查询首页数据
        indexViewModel.queryIndexPageStrategyListBusiness.execute()
    }
    
    // MARK: - KVO
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if keyPath == kData {
            
            let newValue: AnyObject? = change[NSKeyValueChangeNewKey]
            
            if let newValue=newValue as? [StrategyModel] {
                
                println(newValue)
            }
        }
    }
}
