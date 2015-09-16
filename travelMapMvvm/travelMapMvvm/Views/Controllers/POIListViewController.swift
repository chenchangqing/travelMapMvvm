//
//  POIListViewController.swift
//  travelMapMvvm
//
//  Created by green on 15/9/16.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import ReactiveCocoa

class POIListViewController: UITableViewController {
    
    // MARK: - View Model
    
    var poiListViewModel: POIListViewModel!
    
    // MARK: - TABLE Cell
    
    let kCellIdentifier = "cell"

    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.header.beginRefreshing()
    }
    
    // MARK: - Set Up
    
    private func setUp() {
        
        setUpMJRefresh()
        setUpCommands()
        setUpMessage()
    }
    
    // MARK: - 初始化MJRefresh
    
    private func setUpMJRefresh() {
        
        tableView.header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            
            // 查询数据
            self.poiListViewModel.refreshCommand.execute(nil)
        })
        
        tableView.footer = MJRefreshBackNormalFooter { () -> Void in
            
            // 查询数据
            self.poiListViewModel.loadmoreCommand.execute(nil)
        }
        tableView.footer.automaticallyChangeAlpha = true
    }
    
    // MARK: - Set Up Commands
    
    private func setUpCommands() {
        
        poiListViewModel.refreshCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
                // 更新数据
                self.poiListViewModel.poiList = any as! [POIModel]
                
                self.tableView.reloadData()
                
            }, error: { (error:NSError!) -> Void in
                
                self.poiListViewModel.failureMsg = error.localizedDescription
                
            }, completed: { () -> Void in
                
                self.tableView.header.endRefreshing()
                self.tableView.footer.resetNoMoreData()
            })
        }
        
        poiListViewModel.loadmoreCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
                // 更新数据
                self.poiListViewModel.poiList = any as! [POIModel]
                
                self.tableView.reloadData()
                
            }, error: { (error:NSError!) -> Void in
                
                self.poiListViewModel.failureMsg = error.localizedDescription
                
            }, completed: { () -> Void in
                
                self.tableView.footer.endRefreshing()
            })
        }
    }
    
    // MARKO: - Setup Message 成功失败提示 加载提示
    
    private func setUpMessage() {
        
        RACSignal.combineLatest([
            RACObserve(poiListViewModel, "failureMsg"),
            RACObserve(poiListViewModel, "successMsg"),
            poiListViewModel.loadmoreCommand.executing,
            poiListViewModel.refreshCommand.executing
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
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.poiListViewModel.poiList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! UITableViewCell
        
        // 解决模拟器越界 避免设置数据与reloadData时间差引起的错误
        if indexPath.row < self.poiListViewModel.poiList.count {
            
            let item: AnyObject = self.poiListViewModel.poiList[indexPath.row]
            if let reactiveView = cell as? ReactiveView {
                reactiveView.bindViewModel(item)
            }
        }
        
        return cell
    }

}
