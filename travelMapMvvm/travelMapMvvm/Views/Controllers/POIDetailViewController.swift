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
    @IBOutlet weak var textViewContainer    : UIView!
    
    @IBOutlet weak var poiDescTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var poiAddressTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var poiOpenTimeTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var poiTiketTextViewHeightConstraint: NSLayoutConstraint!
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
        
        bindViewModel()
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
            let textViewContainerHeight = self.poiDescTextViewHeightConstraint.constant + self.poiAddressTextViewHeightConstraint.constant + self.poiOpenTimeTextViewHeightConstraint.constant + self.poiTiketTextViewHeightConstraint.constant + 32
            
            self.textViewContainer.setHeight(textViewContainerHeight)
            self.view.layoutIfNeeded()
        }
    }

}
