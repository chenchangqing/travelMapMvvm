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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        footer.hidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        footer.hidden = true
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
                
                self.showHUDIndicator()
            } else {
                
                if failureMsg.isEmpty && successMsg.isEmpty {
                    
                    self.hideHUD()
                }
            }
            
            if !failureMsg.isEmpty {
                
                self.showHUDErrorMessage(failureMsg)
            }
            
            if !successMsg.isEmpty {
                
                self.showHUDMessage(successMsg)
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
        self.strategyListViewModel.refreshCommand.executionSignals.switchToLatest().dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
            
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
        
        // 上拉加载
        self.strategyListViewModel.loadmoreCommand.executionSignals.switchToLatest().dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
            
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
    
    // MARK: - Navigation
    
    @IBAction func unwindSegueToIndexViewController(segue: UIStoryboardSegue) {
        
        if segue.identifier == kSegueFromFilterViewControllerToIndexViewController {
            
        }
        
        if segue.identifier == kSegueFromDesViewControllerToIndexViewController {
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // 跳转至攻略详情页面
        if segue.identifier == kSegueFromIndexViewControllerToStrategyDetailViewController {
            
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
        
        self.performSegueWithIdentifier(kSegueFromIndexViewControllerToStrategyDetailViewController, sender: self.strategyListViewModel.strategyList[indexPath.row])
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
}
