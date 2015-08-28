//
//  IndexViewController.swift
//  travelMapMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import ReactiveCocoa

/**
 * 首页控制器
 */
class IndexViewController: UITableViewController {
    
    private var viewModel: IndexViewModel!
    private var bindingHelper: TableViewBindingHelper!

    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

    }
    
    // MARK: - setup
    
    private func setup() {
        
        viewModel = IndexViewModel()
        
        bindingHelper = TableViewBindingHelper(tableView: self.tableView, sourceSignal: RACObserve(viewModel, "strategyList"), reuseIdentifier: "cell", cellHeight: 200, selectionCommand: nil)
        
    }
}
