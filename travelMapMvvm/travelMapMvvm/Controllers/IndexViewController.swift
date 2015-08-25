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
    
    private var viewModel: IndexViewModelProtocol!

    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        // 查询首页攻略列表
        viewModel.queryIndexPageStrategyList()
    }
    
    // MARK: - setup
    
    private func setup() {
        
        // 初始化ViewModel
        setupViewModel()
    }
    
    private func setupViewModel() {
        
        viewModel = IndexViewModel.shareInstance({ (success, msg, data) -> Void in
            
            println(data)
        })
    }

    // MARK: -
}
