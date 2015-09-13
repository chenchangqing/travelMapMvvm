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
    @IBOutlet weak var textView : UITextView!   // POI 详细
    @IBOutlet weak var textViewContainer: UIView!
    
    // MARK: - View Model
    
    var poiDetailViewModel:POIDetailViewModel!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        textViewContainer.setHeight(800)
        self.view.layoutIfNeeded()
        
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
    }

}
