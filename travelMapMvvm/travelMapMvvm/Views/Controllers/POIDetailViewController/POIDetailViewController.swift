//
//  POIDetailViewController.swift
//  travelMapMvvm
//
//  Created by green on 15/9/13.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import ReactiveCocoa

class POIDetailViewController: UITableViewController {
    
    // MARK: - UI
    @IBOutlet weak var poiPicV  : UIImageView!  // POI 图片
    @IBOutlet weak var poiNameL : UILabel!      // POI 名称
    @IBOutlet weak var levelV   : RatingBar!    // POI 评分
    
    @IBOutlet weak var poiDescTextView      : UITextView!   // POI 简介
    @IBOutlet weak var poiAddressTextView   : UITextView!   // POI 地址
    @IBOutlet weak var poiOpenTimeTextView  : UITextView!   // POI 开放时间
    @IBOutlet weak var poiTiketTextView     : UITextView!   // POI 票价
    
    @IBOutlet weak var topViewContainer     : UIView!
    @IBOutlet weak var headerViewContainer  : UIView!
    
    @IBOutlet weak var poiDescTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var poiAddressTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var poiOpenTimeTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var poiTiketTextViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - TABLE Cell
    
    let kCellIdentifier = "cell"
    
    // MARK: - View Model
    
    var poiDetailViewModel:POIDetailViewModel!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    // MARK: - SetUp
    
    private func setup() {
        
        setupCommand()
        bindViewModel()
        setupMessage()
    }
    
    // MARK: - Bind ViewModel
    
    private func bindViewModel() {
        
        // POI 图片
        RACObserve(self, "poiDetailViewModel.poiImageViewModel.image") ~> RAC(poiPicV,"image")
        
        // POI 名称
        RACObserve(self, "poiDetailViewModel.poiModel.poiName") ~> RAC(poiNameL,"text")
        
        // POI 评分
        RACObserve(self, "poiDetailViewModel.poiModel").ignore(nil).map{ (poiModel:AnyObject!) -> AnyObject! in
            
            let poiModel = poiModel as! POIModel
            if let level = poiModel.level {
                
                return CGFloat(level.index+1)
            }
            return nil
        }.ignore(nil) ~> RAC(levelV,"rating")
        
        // POI 详细
        RACObserve(self, "poiDetailViewModel.poiModel").ignore(nil).subscribeNext { (any:AnyObject!) -> Void in
            
            // textView width
            let textViewWidth = UIScreen.mainScreen().bounds.width - 20
            
            let attributeStringTuple = self.poiDetailViewModel.getPOITextViewData(any as! POIModel)
            self.poiDescTextView.attributedText = attributeStringTuple.poiDesc
            self.poiAddressTextView.attributedText = attributeStringTuple.poiAddress
            self.poiOpenTimeTextView.attributedText = attributeStringTuple.openTime
            self.poiTiketTextView.attributedText = attributeStringTuple.poiTiket
            
            self.poiDescTextViewHeightConstraint.constant = self.poiDescTextView.height(textViewWidth)
            self.poiAddressTextViewHeightConstraint.constant = self.poiAddressTextView.height(textViewWidth - 40 - 6)
            self.poiOpenTimeTextViewHeightConstraint.constant = self.poiOpenTimeTextView.height(textViewWidth)
            self.poiTiketTextViewHeightConstraint.constant = self.poiTiketTextView.height(textViewWidth)
            
            // textViewContainer Height
            let textViewContainerHeight = self.poiDescTextViewHeightConstraint.constant + self.poiAddressTextViewHeightConstraint.constant + self.poiOpenTimeTextViewHeightConstraint.constant + self.poiTiketTextViewHeightConstraint.constant + 32 + 33
            
            self.headerViewContainer.setHeight(self.topViewContainer.height() + textViewContainerHeight)
            self.view.layoutIfNeeded()
            
            // 查询评论列表
            self.poiDetailViewModel.searchCommentsCommand.execute(nil)
        }
    }
    
    // MARK: - SETUP Command
    
    private func setupCommand() {
        
        poiDetailViewModel.searchCommentsCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
            
                // 处理POI评论列表
                self.poiDetailViewModel.comments = any as! [CommentModel]
                self.tableView.reloadData()
            
            }, error: { (error:NSError!) -> Void in
                
                self.poiDetailViewModel.failureMsg = error.localizedDescription
                
            }, completed: { () -> Void in
                
                //                println("completed")
            })
        }
    }
    
    // MARKO: - Setup Message
    
    /**
     * 成功失败提示
     */
    private func setupMessage() {
        
        RACSignal.combineLatest([
            RACObserve(poiDetailViewModel, "failureMsg"),
            RACObserve(poiDetailViewModel, "successMsg"),
            poiDetailViewModel.searchCommentsCommand.executing
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
