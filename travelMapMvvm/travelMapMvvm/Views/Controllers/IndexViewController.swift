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
    private var footer:IndexViewFooter!

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
     * 初始化重用footer
     */
    private func setupFooter() {
        
        footer = NSBundle.mainBundle().loadNibNamed("IndexViewFooter", owner: nil, options: nil).first as? IndexViewFooter
        
        if let footer=footer {
            
            footer.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.navigationController?.view.addSubview(footer)
            
            // constrains
            self.navigationController?.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[footer]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["footer":footer]))
            self.navigationController?.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[footer(50)]-16-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["footer":footer]))
            
            // 跳转至筛选页面
            footer.goFilterBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext({ (any:AnyObject!) -> Void in
                
                self.performSegueWithIdentifier(kSegueFromIndexViewControllerToFilterViewController, sender: nil)
            })
            
            // 跳转至排序页面
            footer.goOrderBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext({ (any:AnyObject!) -> Void in
                
                self.performSegueWithIdentifier(kSegueFromIndexViewControllerToDesViewController, sender: nil)
            })
        }
    }
    
    /**
     * 初始化viewModel
     */
    private func setupIndexViewModel() {
        
        viewModel = IndexViewModel()
        
        self.viewModel.refreshSearch.executing.subscribeNextAs({ (isExecuting:Bool) -> () in
            
            if isExecuting {
                
                self.showHUDIndicator()
            } else {
                
                if !self.viewModel.errorMsg.isEmpty {
                    
                    self.showHUDErrorMessage(self.viewModel.errorMsg)
                } else {
                    
                    self.hideHUD()
                }
            }
        })
        
        self.viewModel.loadmoreSearch.executing.subscribeNextAs({ (isExecuting:Bool) -> () in
            
            if isExecuting {
                
                self.showHUDIndicator()
            } else {
                
                if !self.viewModel.errorMsg.isEmpty {
                    
                    self.showHUDErrorMessage(self.viewModel.errorMsg)
                } else {
                    
                    self.hideHUD()
                }
            }
        })
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
        
        // 更新tableView
        bindingHelper = TableViewBindingHelper(
            tableView: tableView,
            sourceSignal: RACObserve(viewModel, "strategyList").doNext { (any:AnyObject!) -> Void in
                
                self.callbackAfterGetData(any)
            },
            reuseIdentifier: kCellIdentifier, cellHeight: 200, selectionCommand: nil)
    }
    
    // MARK: - 请求数据之后回调
    
    /**
     * 请求数据之后回调
     */
    private func callbackAfterGetData(any:AnyObject!) {
        
        // 停止提示动画开始渐变动画
        self.stopIndicatorAnimationAndStartFadeAnimation()
        
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
    
    // MARK: - Navigation
    
    @IBAction func unwindSegueToIndexViewController(segue: UIStoryboardSegue) {
        
        if segue.identifier == kSegueFromFilterViewControllerToIndexViewController {
            
        }
        
        if segue.identifier == kSegueFromDesViewControllerToIndexViewController {
            
        }
    }
}
