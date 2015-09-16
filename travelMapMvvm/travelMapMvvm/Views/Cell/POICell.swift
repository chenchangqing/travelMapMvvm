//
//  POICell.swift
//  travelMap
//
//  Created by green on 15/6/10.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit
import ReactiveCocoa

class POICell: UITableViewCell, ReactiveView {

    @IBOutlet weak var poiPic: UIImageView!
    @IBOutlet weak var star: RatingBar!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var poiName: UILabel!
    
    private var poiImageViewModel = ImageViewModel(urlString: nil)
    
    // MARK: - init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Observe
        RACObserve(poiImageViewModel, "image") ~> RAC(poiPic,"image")
        
        self.rac_prepareForReuseSignal.subscribeNext { (any:AnyObject!) -> Void in
            
            self.poiPic.image = nil
        }
    }
    
    // MARK: - ReactiveView
    
    func bindViewModel(viewModel: AnyObject) {
        
        if let viewModel = viewModel as? POIModel {
            
            if let level=viewModel.level {
                
                self.star.rating = CGFloat(level.index+1)
            }
            
            score.text = viewModel.score
            
            poiName.text    = viewModel.poiName
            
            // 加载小编头像图片
            poiImageViewModel.urlString = viewModel.poiPicUrl
            poiImageViewModel.downloadImageCommand.execute(nil)
        }
    }
}
