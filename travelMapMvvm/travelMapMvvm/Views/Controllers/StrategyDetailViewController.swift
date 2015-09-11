//
//  StrategyDetailViewController.swift
//  travelMapMvvm
//
//  Created by green on 15/9/9.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import GONMarkupParser
import ReactiveCocoa

class StrategyDetailViewController: UIViewController {
    
    // MARK:- UI
    @IBOutlet weak var strategyDetailView       : UITextView!           // 攻略详情文本
    @IBOutlet weak var textHeightConstraint     : NSLayoutConstraint!   // 攻略详情文本高度约束
    @IBOutlet weak var textVerticalConstraint   : NSLayoutConstraint!   // 攻略详情文本上边距
    @IBOutlet weak var hideTextViewButton       : UIButton!             // 隐藏详情文本按钮
    var detailButton                            : UIBarButtonItem!      // 现实攻略详情按钮
    var collectButton                           : UIBarButtonItem!      // 收藏攻略按钮
    
    var strategyDetailViewModel : StrategyDetailViewModel!  // 攻略view model
    var textViewHeight          : CGFloat!                  // 攻略详情文本实际高度

    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // 默认隐藏攻略详情文本
        self.textVerticalConstraint.constant = -UIScreen.mainScreen().bounds.height
    }

    // MARK: - SETUP
    
    private func setup() {
        
        setupRightButtons()         // 初始化详情、收藏按钮
        setupStrategyDetailView()   // 初始化攻略文本
        setupEvent()                // 初始化按钮事件
        setupCommand()              // 监视命令执行设置
        setupMessage()              // 监视提示信息
    }
    
    /**
     * 初始化详情按钮、收藏按钮、隐藏攻略文本按钮
     */
    private func setupRightButtons() {
        
        detailButton = UIBarButtonItem(title: "详情", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("detailButtonClicked:"))
        
        collectButton = UIBarButtonItem(title: "收藏", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        
        self.navigationItem.rightBarButtonItems = [detailButton,collectButton]
        
        hideTextViewButton.loginBorderStyle()
    }
    
    /**
     * 初始化攻略文本
     */
    private func setupStrategyDetailView() {
        
        self.strategyDetailView.attributedText = strategyDetailViewModel.getStrategyTextViewData()
        // 调整高度
        let textViewWidth = UIScreen.mainScreen().bounds.width - 16
        let textViewMaxH = UIScreen.mainScreen().bounds.height - 72/** 导航+20 **/ - 56/** 收起按钮上下边距+自身高度 **/
        var textViewHeight = self.strategyDetailView.height(textViewWidth)
        textViewHeight = textViewHeight > textViewMaxH ? textViewMaxH : textViewHeight
        
        self.textHeightConstraint.constant = textViewHeight
    }
    
    /**
     * 初始化事件
     */
    private func setupEvent() {
        
        hideTextViewButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (any:AnyObject!) -> Void in
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.textVerticalConstraint.constant = -UIScreen.mainScreen().bounds.height
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func detailButtonClicked(detailButton:UIBarButtonItem) {
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.textVerticalConstraint.constant = 64
            self.view.layoutIfNeeded()
        })
    }
    
    /**
     * 命令设置
     */
    private func setupCommand() {
        
        strategyDetailViewModel.searchStrategyListCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
                // 处理POI列表
                println(any)
                
            }, error: { (error:NSError!) -> Void in
                
                self.strategyDetailViewModel.failureMsg = error.localizedDescription
            }, completed: { () -> Void in
                
                println("completed")
            })
        }
        
        strategyDetailViewModel.active = true
    }
    
    /**
     * 成功失败提示
     */
    private func setupMessage() {
        
        RACSignal.combineLatest([
            RACObserve(strategyDetailViewModel, "failureMsg"),
            RACObserve(strategyDetailViewModel, "successMsg"),
            strategyDetailViewModel.searchStrategyListCommand.executing
        ]).subscribeNextAs { (tuple: RACTuple) -> () in
            
            let failureMsg  = tuple.first as! String
            let successMsg  = tuple.second as! String
            
            let isLoading   = tuple.third as! Bool
            
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
    
}
