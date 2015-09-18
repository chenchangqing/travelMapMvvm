//
//  StrategyCell2.swift
//  travelMapMvvm
//
//  Created by green on 15/9/18.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import ReactiveCocoa

class StrategyCell2: UITableViewCell, ReactiveView {
    
    // MARK: - UI
    
    @IBOutlet weak var strategyPic: UIImageView!
    @IBOutlet weak var strategyNameL: UILabel!
    @IBOutlet weak var visiteNumL: UILabel!
    @IBOutlet weak var authorNameL: UILabel!
    
    // MARK: - View Model
    
    private var strategyImageViewModel: ImageViewModel!
    
    // MARK: - Init

    override func awakeFromNib() {
        super.awakeFromNib()

        // 设置View Model
        strategyImageViewModel = ImageViewModel(urlString: nil, defaultImage:UIImage(named: "defaultImage.jpg")!)
        
        // 绑定View Model
        RACObserve(strategyImageViewModel, "image") ~> RAC(self.strategyPic,"image")
        
        // 重置图片
        self.rac_prepareForReuseSignal.subscribeNext { (any:AnyObject!) -> Void in
            
            self.strategyPic.image = nil
        }

    }

    // MARK: - ReactiveView
    
    func bindViewModel(viewModel: AnyObject) {
        
        if let strategyModel = viewModel as? StrategyModel {
            
            self.strategyNameL.text = strategyModel.title
            self.visiteNumL.text    = "浏览量：\(strategyModel.visitNumber!)次"
            self.authorNameL.text   = "作者：\(strategyModel.author!)"
            
            self.strategyImageViewModel.urlString = strategyModel.picUrl
            self.strategyImageViewModel.downloadImageCommand.execute(nil)
        }
    }
}
