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
    private let kCellIdentifier = "cell"
    private var bindingHelper: TableViewBindingHelper!
    private var footer:UIView!

    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        setupFooter()
        setupIndexViewModel()
        setupMJRefresh()
        setupObserve()
        
        // 提示动画
        self.indicatorView.startAnimation()
        
        // 马上进入刷新状态
        tableView.header.beginRefreshing()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        footer.hidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        footer.hidden = true
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
        tableView.footer.automaticallyChangeAlpha = true
    }
    
    /**
     * 初始化属性观察
     */
    private func setupObserve() {
        
        // 如果出现错误则提示
        RACObserve(viewModel, "errorMsg").subscribeNextAs { (errorMsg:String) -> () in
            if !errorMsg.isEmpty {
                
                self.showHUDErrorMessage(errorMsg)
            }
        }
        
        // 更新tableView
        bindingHelper = TableViewBindingHelper(
            tableView: tableView,
            sourceSignal: RACObserve(viewModel, "strategyList").doNext { (any:AnyObject!) -> Void in
                
                self.callbackAfterGetData(any)
            },
            reuseIdentifier: kCellIdentifier, cellHeight: 200, selectionCommand: nil)
    
    }
    
    /**
     * 初始化重用footer
     */
    private func setupFooter() {
        
        footer = NSBundle.mainBundle().loadNibNamed("IndexViewFooter", owner: nil, options: nil).first as? UIView
        if let footer=footer {
            
            footer.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.navigationController?.view.addSubview(footer)
            
            // constrains
        self.navigationController?.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[footer]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["footer":footer]))
        self.navigationController?.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[footer(50)]-16-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["footer":footer]))
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
        
        // 显示footer
        if footer.hidden {
            
            footer.hidden = false
        }
        
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
