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
        
        // 注册KVO
        indexViewModel.indexViewObservedModel.addObserver(self, forKeyPath: pStrategyList, options: NSKeyValueObservingOptions.New, context: nil)
        
        // 查询首页数据
        indexViewModel.refreshStrategyList()
    }
    
    deinit {
    
        // 注销KVO
        indexViewModel.indexViewObservedModel.removeObserver(self, forKeyPath: pStrategyList)
    }
    
    // MARK: - setup
    
    private func setup() {
        
    }
    
    // MARK: - KVO
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if keyPath == pStrategyList {
            
            let newValue: AnyObject? = change[NSKeyValueChangeNewKey]
            
            if let newValue=newValue as? [StrategyModel] {
                
                // 刷新table
            }
        }
    }
}
