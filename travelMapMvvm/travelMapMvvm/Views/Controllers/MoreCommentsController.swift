//
//  MoreMomentsController.swift
//  travelMapMvvm
//
//  Created by green on 15/9/14.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import ReactiveCocoa
import KGModal

class MoreCommentsController: UITableViewController {
    
    // MARK: - View Model
    
    var moreCommentViewModel: MoreCommentsViewModel!
    
    // MARK: - TABLE Cell
    
    let kCellIdentifier = "cell"
    
    // MARK: - 评论表单
    
    lazy var commentFormController = UIViewController.getViewController("CommentForm", identifier: "CommentFormController") as! CommentFormController
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupMJRefresh()
        setupCommands()
        setupMessage()
        
        self.tableView.header.beginRefreshing()
    }
    
    // MARK: - Bind View Model
    
    private func bindViewModel() {
        
        RACObserve(self.moreCommentViewModel, "addedCommentModel").ignore(nil).subscribeNextAs { (addedCommentModel:CommentModel) -> () in
            
            let commentsDic = CommentCell.caculateCellHeight([addedCommentModel])
            self.moreCommentViewModel.comments[addedCommentModel] = commentsDic[addedCommentModel]
            self.tableView.reloadData()
        }
    }
    
    // MARK: - 初始化MJRefresh
    
    private func setupMJRefresh() {
        
        tableView.header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            
            // 查询数据
            self.moreCommentViewModel.refreshCommand.execute(nil)
        })
        
        tableView.footer = MJRefreshBackNormalFooter { () -> Void in
            
            // 查询数据
            self.moreCommentViewModel.loadmoreCommand.execute(nil)
        }
        tableView.footer.automaticallyChangeAlpha = true
    }
    
    // MARK: - Set Up Commands
    
    private func setupCommands() {
        
        moreCommentViewModel.refreshCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
                // 更新数据
                self.moreCommentViewModel.comments = CommentCell.caculateCellHeight(any as! [CommentModel])
            
                self.tableView.reloadData()
            
            }, error: { (error:NSError!) -> Void in
                
                self.moreCommentViewModel.failureMsg = error.localizedDescription
                
            }, completed: { () -> Void in
                
                self.tableView.header.endRefreshing()
                self.tableView.footer.resetNoMoreData()
            })
        }
        
        moreCommentViewModel.loadmoreCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
                // 更新数据
                self.moreCommentViewModel.comments = CommentCell.caculateCellHeight(any as! [CommentModel])
                
                self.tableView.reloadData()
                
            }, error: { (error:NSError!) -> Void in
                
                self.moreCommentViewModel.failureMsg = error.localizedDescription
                
            }, completed: { () -> Void in
                
                self.tableView.footer.endRefreshing()
            })
        }
    }
    
    // MARKO: - Setup Message 成功失败提示 加载提示
    
    private func setupMessage() {
        
        RACSignal.combineLatest([
            RACObserve(moreCommentViewModel, "failureMsg"),
            RACObserve(moreCommentViewModel, "successMsg"),
            moreCommentViewModel.loadmoreCommand.executing,
            moreCommentViewModel.refreshCommand.executing
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
        return self.moreCommentViewModel.comments.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! UITableViewCell
        
        // 解决模拟器越界 避免设置数据与reloadData时间差引起的错误
        if indexPath.row < self.moreCommentViewModel.comments.count {
            
            let item: AnyObject = self.moreCommentViewModel.comments.keys[indexPath.row]
            if let reactiveView = cell as? ReactiveView {
                reactiveView.bindViewModel(item)
            }
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return CGFloat(self.moreCommentViewModel.comments[self.moreCommentViewModel.comments.keys[indexPath.row]]!.integerValue)
    }
    
    // MARK: - 新增评论
    
    @IBAction func addCommentAction(sender: AnyObject) {
        
        if self.commentFormController.commentFormViewModel == nil {
            self.commentFormController.commentFormViewModel = CommentFormViewModel(moreCommentsViewModel: self.moreCommentViewModel)
        }
        
        KGModal.sharedInstance().showWithContentViewController(self.commentFormController, andAnimated :true)
    }
}
