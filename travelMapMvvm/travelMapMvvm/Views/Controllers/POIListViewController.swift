//
//  POIListViewController.swift
//  travelMapMvvm
//
//  Created by green on 15/9/16.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import ReactiveCocoa

class POIListViewController: UITableViewController,THSegmentedPageViewControllerDelegate {
    
    // MARK: - View Model
    
    var poiListViewModel = POIListViewModel()
    
    // MARK: - Cell Identifier
    
    private let kCellIdentifier1 = "Cell1"
    private let kCellIdentifier2 = "Cell2"

    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        
        // 首次进入是否应该加载数据
        shouldLoadData()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == kSegueFromPOIListViewControllerToPOIDetailViewController {
            
            if let poiModel = sender as? POIModel {
                
                let poiDetailViewController = segue.destinationViewController as! POIDetailViewController
                poiDetailViewController.poiDetailViewModel = POIDetailViewModel(poiModel: poiModel)
            }
            
            if let cityModel = sender as? CityModel {
                
            }
        }
        
        if segue.identifier == kSegueFromPOIListViewControllerToPOIContainerController {
            
            if let cityModel = sender as? CityModel {
                
                let poiContainerController = segue.destinationViewController as! POIContainerController
                poiContainerController.poiContainerViewModel = POIContainerViewModel(paramTuple:  (QueryTypeEnum.POIListByCityId, param: cityModel.cityId!))
            }
        }
    }
    
    // MARK: - 首次进入是否应该加载数据
    
    private func shouldLoadData() {
        
        switch (self.poiListViewModel.paramTuple.queryType)
        {
            case .POIListByCenterPOIId,.POIListByCityId,.POIListByStrategyId,.POIListByUserId:
                
                // 首次进入刷新
                self.tableView.header.beginRefreshing()
                
                break;
                
            case .POIListByKeyword:
                
                
                self.poiListViewModel.poiList = []
                self.tableView.reloadData()
                
                self.poiListViewModel.refreshCommand.execute(nil)
                self.poiListViewModel.searchCityListCommand.execute(nil)
                
                break;
                
            default:
                
                break;
        }
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
                
                if self.poiListViewModel.poiList.count > 0 {
                    
                    self.poiListViewModel.resultList = self.poiListViewModel.cityList + self.poiListViewModel.poiList
                }
                
            }, error: { (error:NSError!) -> Void in
                
                self.poiListViewModel.failureMsg = error.localizedDescription
                self.tableView.header.endRefreshing()
                self.tableView.footer.resetNoMoreData()
                
            }, completed: { () -> Void in
                
                self.tableView.header.endRefreshing()
                self.tableView.footer.resetNoMoreData()
            })
        }
    
        poiListViewModel.loadmoreCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
        
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
                // 更新数据
                self.poiListViewModel.poiList = any as! [POIModel]
                
                if self.poiListViewModel.poiList.count > 0 {
                    
                    self.poiListViewModel.resultList = self.poiListViewModel.cityList + self.poiListViewModel.poiList
                }
                
            }, error: { (error:NSError!) -> Void in
                
                self.poiListViewModel.failureMsg = error.localizedDescription
                self.tableView.header.endRefreshing()
                self.tableView.footer.resetNoMoreData()
                
            }, completed: { () -> Void in
                
                self.tableView.footer.endRefreshing()
            })
        }
        
        poiListViewModel.searchCityListCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
                // 更新城市
                self.poiListViewModel.cityList = any as! [CityModel]
                
                if self.poiListViewModel.cityList.count > 0 {
                    
                    self.poiListViewModel.resultList = self.poiListViewModel.cityList + self.poiListViewModel.poiList
                }
                
            }, error: { (error:NSError!) -> Void in
                
                self.poiListViewModel.failureMsg = error.localizedDescription
                
            }, completed: { () -> Void in
                
            })
        }
        
        // 更新数据
        RACObserve(self.poiListViewModel, "resultList").subscribeNext { (any:AnyObject!) -> Void in
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Setup Message
    
    private func setUpMessage() {
        
        RACSignal.combineLatest([
            RACObserve(poiListViewModel, "failureMsg"),
            RACObserve(poiListViewModel, "successMsg"),
            poiListViewModel.loadmoreCommand.executing,
            poiListViewModel.refreshCommand.executing,
            poiListViewModel.searchCityListCommand.executing,
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
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.poiListViewModel.resultList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell!
        
        switch (self.poiListViewModel.paramTuple.queryType)
        {
            
            case .POIListByCenterPOIId,.POIListByCityId,.POIListByStrategyId,.POIListByUserId:
                
                cell = self.tableView.dequeueReusableCellWithIdentifier(kCellIdentifier1) as! UITableViewCell
                
                break;
                
            case .POIListByKeyword:
                
                cell = self.tableView.dequeueReusableCellWithIdentifier(kCellIdentifier2) as! UITableViewCell
                
                break;
                
            default:
                
                break;
        }
        
        // 解决模拟器越界 避免设置数据与reloadData时间差引起的错误
        if indexPath.row < self.poiListViewModel.resultList.count {
            
            if let reactiveView = cell as? ReactiveView {
                
                reactiveView.bindViewModel(self.poiListViewModel.resultList[indexPath.row])
            }
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let poiModel = self.poiListViewModel.resultList[indexPath.row] as? POIModel {
            
            self.performSegueWithIdentifier(kSegueFromPOIListViewControllerToPOIDetailViewController, sender: poiModel)
        }
        
        if let cityModel = self.poiListViewModel.resultList[indexPath.row] as? CityModel {
            
            self.performSegueWithIdentifier(kSegueFromPOIListViewControllerToPOIContainerController, sender: cityModel)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch (self.poiListViewModel.paramTuple.queryType)
        {
            case .POIListByCenterPOIId,.POIListByCityId,.POIListByStrategyId,.POIListByUserId:
                
                return 250
                
            case .POIListByKeyword:
                
                return 100
                
            default:
                
                break;
        }
        return 0
    }
    
    // MARK: - THSegmentedPageViewControllerDelegate
    
    func viewControllerTitle() -> String! {
        
        return self.title
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
