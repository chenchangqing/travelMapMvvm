//
//  CommentFormController.swift
//  travelMapMvvm
//
//  Created by green on 15/9/14.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import ReactiveCocoa

class CommentFormController: UIViewController {
    
    // MARK: - UI
    
    @IBOutlet weak var levelV: RatingBar!
    @IBOutlet weak var poiPicV: UIImageView!
    @IBOutlet weak var poiNameL: UILabel!
    @IBOutlet weak var commentTextArea: UITextView!
    @IBOutlet weak var sureBtn: UIButton!
    
    @IBOutlet weak var placeHolder: UILabel!
    @IBOutlet weak var scrollV: UIScrollView!
    
    // MARK: - View Model
    
    var commentFormViewModel: CommentFormViewModel!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
    
    // MARK: - 设置UI
    
    private func setupUI() {
        
        view.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds) * 0.8 , CGRectGetHeight(UIScreen.mainScreen().bounds) * 0.8)
        
        sureBtn.loginBorderStyle()
    }
    
    
    // MARK: - Bind View Model
    
    private func bindViewModel() {
        
        // POI 图片
        RACObserve(self, "commentFormViewModel.moreCommentsViewModel.poiDetailViewModel.poiImageViewModel.image") ~> RAC(poiPicV,"image")
        
        // POI 名称
        RACObserve(self, "commentFormViewModel.moreCommentsViewModel.poiDetailViewModel.poiModel.poiName") ~> RAC(poiNameL,"text")
        
        // POI 评分
        RACObserve(self, "commentFormViewModel.moreCommentsViewModel.poiDetailViewModel.poiModel").ignore(nil).map{ (poiModel:AnyObject!) -> AnyObject! in
            
            let poiModel = poiModel as! POIModel
            if let level = poiModel.level {
                
                return CGFloat(level.index+1)
            }
            return nil
        }.ignore(nil) ~> RAC(levelV,"rating")
        
        //
    }
}
