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
        
        // 初始化
        setupIndexViewModel()
        setupTableView()
        
        // 提示动画
        self.indicatorView.startAnimation()
        
        // 延时3秒查询数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 3)), dispatch_get_main_queue(), { () -> Void in
        
            self.viewModel.executeSearch.execute(nil)
        })

    }
    
    // MARK: - setup
    
    /**
     * 初始化viewModel
     */
    private func setupIndexViewModel() {
        
        viewModel = IndexViewModel()
    }
    
    /**
     * 初始化tableView
     */
    private func setupTableView() {
        
        bindingHelper = TableViewBindingHelper(
            tableView: self.tableView,
            sourceSignal: RACObserve(viewModel, "strategyList").doNext { (any:AnyObject!) -> Void in
                
                self.indicatorView.stopAnimation()
                self.executeFadeAnimation()
            },
            reuseIdentifier: "cell",
            cellHeight: 200,
            selectionCommand: nil)
    }
    
    // MARK: - 动画
    
    /**
     * 动画
     */
    private func executeFadeAnimation() {
        
        var animated = CATransition()
        animated.duration = 1.0
        animated.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animated.type = kCATransitionFade
        animated.removedOnCompletion = true
        
        self.view.layer.addAnimation(animated, forKey: nil)
    }
}
