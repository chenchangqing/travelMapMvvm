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

    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        setupIndexViewModel()
        setupMJRefresh()
        
        // 如果出现错误则提示
        RACObserve(viewModel, "errorMsg").subscribeNextAs { (errorMsg:String) -> () in
            if !errorMsg.isEmpty {
                
                self.showHUDErrorMessage(errorMsg)
            }
        }
        
        // 更新tableView
        RACObserve(viewModel, "strategyList").doNext { (any:AnyObject!) -> Void in
            
            self.callbackAfterGetData(any)
        }.subscribeNext {(d:AnyObject!) -> () in
            
            self.tableView.reloadData()
        }
        
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
    
    // MARK: - 请求数据之后回调
    
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
    
    //MARK: - UITableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.strategyList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item: AnyObject = viewModel.strategyList[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        if let reactiveView = cell as? ReactiveView {
            reactiveView.bindViewModel(item)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 200
    }
    
    override func tableView(tableView: UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath){
        
    }
}
