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
        setupMJRefresh()
        
        // 提示动画
        self.indicatorView.startAnimation()
        
        // 延时3秒查询数据
        self.viewModel.executeSearch.execute(nil)

    }
    
    // MARK: - setup
    
    /**
     * 初始化viewModel
     */
    private func setupIndexViewModel() {
        
        viewModel = IndexViewModel()
    }
    
    /**
     * 初始化MJRefresh
     */
    private func setupMJRefresh() {
        
        tableView.header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 2)), dispatch_get_main_queue(), { () -> Void in
                
                // 拿到当前的下拉刷新控件，结束刷新状态
                self.tableView.header.endRefreshing()
            })
        })
        
        tableView.footer = MJRefreshBackNormalFooter { () -> Void in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 2)), dispatch_get_main_queue(), { () -> Void in
                
                // 拿到当前的上拉刷新控件，结束刷新状态
                self.tableView.footer.endRefreshing()
            })
        }
        
        // 马上进入刷新状态
        tableView.header.beginRefreshing()
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
        animated.type = kCATransitionPush
        animated.subtype = "fromLeft"
        animated.removedOnCompletion = true
        
        self.view.layer.addAnimation(animated, forKey: nil)
    }
}
