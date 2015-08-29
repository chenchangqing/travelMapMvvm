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
        setupMJRefresh()
        setupTableView()
        
        // 提示动画
        self.indicatorView.startAnimation()
        
        // 马上进入刷新状态
        tableView.header.beginRefreshing()

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
            
            // 查询数据
            self.viewModel.refreshSearch.execute(nil)
        })
        
        tableView.footer = MJRefreshBackNormalFooter { () -> Void in
            
            // 查询数据
            self.viewModel.loadmoreSearch.execute(nil)
        }
    }
    
    
    /**
     * 初始化tableView
     */
    private func setupTableView() {
        
        bindingHelper = TableViewBindingHelper(
            tableView: self.tableView,
            sourceSignal: RACObserve(viewModel, "strategyList").doNext { (any:AnyObject!) -> Void in
                self.callbackAfterGetData(any)
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
//        animated.type = kCATransitionPush
//        animated.subtype = "fromLeft"
        animated.type = kCATransitionFade
        animated.removedOnCompletion = true
        
        self.view.layer.addAnimation(animated, forKey: nil)
    }
    
    // MARK: - 
    
    /**
     * 请求数据之后回调
     */
    private func callbackAfterGetData(any:AnyObject!) {
        
        // 开始动画
        if !self.indicatorView.hidden {
            
            self.executeFadeAnimation()
            // 停止提示
            self.indicatorView.stopAnimation()
        }
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        self.tableView.header.endRefreshing()
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        self.tableView.footer.endRefreshing()
        
        // set table status
        if let strategyList=any as? [StrategyModel] {
            
            if strategyList.count > 20 {
                
                self.tableView.footer.noticeNoMoreData()
            } else {
                
                self.tableView.footer.resetNoMoreData()
            }
        }
    }
}
