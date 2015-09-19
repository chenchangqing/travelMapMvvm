//
//  StrategyListViewController.swift
//  travelMapMvvm
//
//  Created by green on 15/9/18.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import ReactiveCocoa

class StrategyListViewController: UITableViewController {

    // MARK: - View Model
    
    var strategyListViewModel = StrategyListViewModel()
    
    // MARK: - Cell Identifier
    
    private let kCellIdentifier1 = "Cell1"
    private let kCellIdentifier2 = "Cell2"
    
    // MARK: - Footer Buttons
    
    private var footer:IndexViewFooter!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        
        // 首次进入是否应该加载数据
        shouldLoadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let footer=footer {
            
            footer.hidden = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let footer=footer {
            
            footer.hidden = true
        }
    }
    
    // MARK: - 首次进入是否应该加载数据
    
    private func shouldLoadData() {
        
        switch (self.strategyListViewModel.paramTuple.queryType)
        {
            case .StrategyListBySystem,.StrategyListByUserId:
                
                // 首次进入刷新
                self.tableView.header.beginRefreshing()
                
                break;
                
            case .StrategyListByKeyword:
                
                self.strategyListViewModel.strategyList = []
                self.tableView.reloadData()
                
                break;
                
            default:
                
                break;
        }
    }
    
    // MARK: - Set Up 
    
    private func setUp() {
        
        setUpFooter()       // 设置查询条件按钮
        setUpMessage()      // 设置友好提示
        setUpMJRefresh()    // 设置MJRefresh
        setUpCommands()     // 设置命令
    }
    
    /**
     * 设置查询条件按钮
     */
    private func setUpFooter() {
        
        if self.strategyListViewModel.paramTuple.queryType == .StrategyListByKeyword {
            
            return
        }
        
        if let navigationController=self.navigationController {
            
            for item in enumerate(navigationController.view.subviews) {
                
                if let footer=item.element as? IndexViewFooter {
                    
                    self.footer = footer
                    break
                }
            }
        }
        
        if self.footer == nil {
            
            footer = NSBundle.mainBundle().loadNibNamed("IndexViewFooter", owner: nil, options: nil).first as? IndexViewFooter
            footer.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.navigationController?.view.addSubview(footer)
            
            // constrains
            self.navigationController?.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[footer]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["footer":footer]))
            self.navigationController?.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[footer(50)]-16-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["footer":footer]))
        }
        
        // 跳转至筛选页面
        footer.goFilterBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext({ (any:AnyObject!) -> Void in
            
            self.performSegueWithIdentifier(kSegueFromStrategyListViewControllerToFilterViewController, sender: nil)
        })
        
        // 跳转至排序页面
        footer.goOrderBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext({ (any:AnyObject!) -> Void in
            
            self.performSegueWithIdentifier(kSegueFromStrategyListViewControllerToDesViewController, sender: nil)
        })
    }
    
    /**
     * 设置友好提示
     */
    private func setUpMessage() {
        
        RACSignal.combineLatest([
            RACObserve(strategyListViewModel, "failureMsg"),
            RACObserve(strategyListViewModel, "successMsg"),
            strategyListViewModel.loadmoreCommand.executing,
            strategyListViewModel.refreshCommand.executing
        ]).subscribeNextAs { (tuple: RACTuple) -> () in
            
            let failureMsg  = tuple.first as! String
            let successMsg  = tuple.second as! String
            
            let isLoading   = tuple.third as! Bool || tuple.fourth as! Bool
            
            if isLoading {
                
                (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController?.showHUDIndicator()
//                self.showHUDIndicator()
            } else {
                
                if failureMsg.isEmpty && successMsg.isEmpty {
                    
                    (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController?.hideHUD()
//                    self.hideHUD()
                }
            }
            
            if !failureMsg.isEmpty {
                
                (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController?.showHUDErrorMessage(failureMsg)
//                self.showHUDErrorMessage(failureMsg)
            }
            
            if !successMsg.isEmpty {
                
                (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController?.showHUDErrorMessage(successMsg)
//                self.showHUDMessage(successMsg)
            }
        }
    }
    
    /**
     * 设置MJRefresh
     */
    private func setUpMJRefresh() {
        
        tableView.header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            
            // 查询数据
            self.strategyListViewModel.refreshCommand.execute(nil)
        })
        
        tableView.footer = MJRefreshBackNormalFooter { () -> Void in
            
            // 查询数据
            self.strategyListViewModel.loadmoreCommand.execute(nil)
        }
        tableView.footer.automaticallyChangeAlpha = true
    }
    
    /**
     * 设置命令
     */
    private func setUpCommands() {
        
        // 下拉刷新
        self.strategyListViewModel.refreshCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
        
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
                self.strategyListViewModel.strategyList = any as! [StrategyModel]
                self.tableView.reloadData()
                
            }, error: { (error:NSError!) -> Void in
                
                self.strategyListViewModel.failureMsg = error.localizedDescription
                
                self.tableView.header.endRefreshing()
                self.tableView.footer.resetNoMoreData()

            }) { () -> Void in
                
                self.tableView.header.endRefreshing()
                self.tableView.footer.resetNoMoreData()

            }
            
        }
        
        // 上拉加载
        self.strategyListViewModel.loadmoreCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
        
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
                self.strategyListViewModel.strategyList += any as! [StrategyModel]
                self.tableView.reloadData()
                
            }, error: { (error:NSError!) -> Void in
                
                self.strategyListViewModel.failureMsg = error.localizedDescription
                
                self.tableView.footer.endRefreshing()
                
            }) { () -> Void in
                
                self.tableView.footer.endRefreshing()
                
                if self.strategyListViewModel.strategyList.count > 20 {
                    
                    self.tableView.footer.noticeNoMoreData()
                }
            }
            
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindSegueToStrategyListViewController(segue: UIStoryboardSegue) {
        
        if segue.identifier == kSegueFromFilterViewControllerToStrategyListViewController {
            
        }
        
        if segue.identifier == kSegueFromDesViewControllerToStrategyListViewController {
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // 跳转至攻略详情页面
        if segue.identifier == kSegueFromStrategyListViewControllerToStrategyDetailViewController {
            
            let strategyViewController = segue.destinationViewController as! StrategyDetailViewController
            
            strategyViewController.strategyDetailViewModel = StrategyDetailViewModel(strategyModel: sender as! StrategyModel)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        switch (self.strategyListViewModel.paramTuple.queryType)
        {
            
            case .StrategyListBySystem,.StrategyListByUserId:
            
                cell = self.tableView.dequeueReusableCellWithIdentifier(kCellIdentifier1) as! UITableViewCell
                
                break;
            
            case .StrategyListByKeyword:
                
                cell = self.tableView.dequeueReusableCellWithIdentifier(kCellIdentifier2) as! UITableViewCell
                
                break;
            
            default:
                
                break;
        }
        
        if let reactiveView = cell as? ReactiveView {
            
            if indexPath.row < self.strategyListViewModel.strategyList.count {
                
                reactiveView.bindViewModel(self.strategyListViewModel.strategyList[indexPath.row])
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.strategyListViewModel.strategyList.count
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.performSegueWithIdentifier(kSegueFromStrategyListViewControllerToStrategyDetailViewController, sender: self.strategyListViewModel.strategyList[indexPath.row])
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch (self.strategyListViewModel.paramTuple.queryType)
        {
            case .StrategyListBySystem,.StrategyListByUserId:
                
                return 200
            
            case .StrategyListByKeyword:
                
                return 100
            
            default:
            
                break;
        }
        return 0
    }
    
    // MARK: - UIScrollViewDelegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {

        if scrollView.contentOffset.y != 0 {

            if let searchViewController = self.parentViewController?.parentViewController?.parentViewController as? SearchViewController {
                
                if searchViewController.mySearchDisplayController.searchBar.isFirstResponder() {
                    
                    searchViewController.mySearchDisplayController.searchBar.resignFirstResponder()
                }
            }
        }
    }
}
