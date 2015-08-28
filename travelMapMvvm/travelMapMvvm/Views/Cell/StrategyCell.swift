//
//  IndexViewCell.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import ReactiveCocoa

/**
 * 攻略Cell 
 */
class StrategyCell: UITableViewCell, ReactiveView  {

    // 攻略图片
    @IBOutlet private weak var strategyPic: UIImageView!
    
    // 攻略名称
    @IBOutlet private weak var strategyNameL: UILabel!
    
    // 攻略创建日期
    @IBOutlet private weak var dateL: UILabel!
    
    // 攻略访问量
    @IBOutlet private weak var visiteNumL: UILabel!
    
    // 小编头像
    @IBOutlet private weak var authorHeadC: GCircleControl!
    
    // 小编名称
    @IBOutlet private weak var authorNameL: UILabel!
    
    // image view model
    private var authImageViewModel          : ImageViewModel!
    private var strategyPicImageViewModel   : ImageViewModel!
    
    // MARK: - init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    // MARK: - setup
    
    private func setup() {
        
        selectionStyle = UITableViewCellSelectionStyle.None
        strategyPic.layer.masksToBounds = true
        strategyPic.layer.cornerRadius = 8
        
        // 小编头像
//        authImageViewModel          = ImageViewModel()
//        
//        RACObserve(authImageViewModel, "image").subscribeNextAs { (image:UIImage!) -> () in
//            
//            self.authorHeadC.image = image
//        }
        
        // 攻略图片
        strategyPicImageViewModel   = ImageViewModel()
        
        RACObserve(strategyPicImageViewModel, "image").subscribeNextAs { (image:UIImage!) -> () in
            
            self.strategyPic.image = image
        }
    }
    
    // MARK: - ReactiveView
    
    func bindViewModel(viewModel: AnyObject) {
        
        if let viewModel = viewModel as? StrategyModel {
            
            // 重用时重置图片
//            self.rac_prepareForReuseSignal.subscribeNext {
//                (next: AnyObject!) -> () in
//                
//                self.authImageViewModel.image = UIImage()
//                self.strategyPicImageViewModel.image = UIImage()
//            }
            
//            strategyNameL.text = viewModel.title
//            dateL.text         = viewModel.createTime
//            visiteNumL.text    = "\(viewModel.visitNumber)"
//            authorNameL.text   = viewModel.author
            
            if let picUrl=viewModel.picUrl {
                
                if let url=NSURL(string: picUrl) {
                    
                    strategyPicImageViewModel.downloadImageWithUrl(url).deliverOn(RACScheduler.mainThreadScheduler())
//                        .takeUntil(self.rac_prepareForReuseSignal)
                        .subscribeNextAs { (result:ResultModel) -> () in
                            
                        self.strategyPic.image = result.data as? UIImage
                    }
                }
            }
            
//            if let picUrl=viewModel.authorPicUrl {
//                
//                if let url=NSURL(string: picUrl) {
//                    
//                authImageViewModel.downloadImageWithUrl(url).deliverOn(RACScheduler.mainThreadScheduler())
//                        .takeUntil(self.rac_prepareForReuseSignal)
//                        .subscribeNextAs { (result:ResultModel) -> () in
//                            
//                        if let image=result.data as? UIImage {
//                            
//                            self.authorHeadC.image = image
//                        }
//                    }
//                }
//            }
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
