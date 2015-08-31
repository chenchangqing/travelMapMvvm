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
    
    // MARK: - init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = UITableViewCellSelectionStyle.None
        strategyPic.layer.masksToBounds = true
        strategyPic.layer.cornerRadius = 8
    }
    
    // MARK: - ReactiveView
    
    func bindViewModel(viewModel: AnyObject) {
        
        if let viewModel = viewModel as? StrategyModel {
            
            // 重用时重置图片
            self.rac_prepareForReuseSignal.subscribeNext {
                (next: AnyObject!) -> () in
                
                self.authorHeadC.image = UIImage()
                self.strategyPic.image = nil
            }
            
            strategyNameL.text = viewModel.title
            dateL.text         = viewModel.createTime
            visiteNumL.text    = viewModel.visitNumber == nil ? "" : "\(viewModel.visitNumber!)"
            authorNameL.text   = viewModel.author
            
            // 加载小编头像
            let authorImageViewModel = ImageViewModel(urlString: viewModel.authorPicUrl)
            RACObserve(authorImageViewModel, "image").subscribeNextAs({ (image:UIImage!) -> () in
                
                self.authorHeadC.image = image
            })
            authorImageViewModel.downloadImageCommand.execute(nil)
            
            // 加载攻略图片
            let strategyImageViewModel = ImageViewModel(urlString: viewModel.picUrl, defaultImage:UIImage(named: "defaultImage.jpg")!)
            RACObserve(strategyImageViewModel, "image").subscribeNextAs({ (image:UIImage!) -> () in
                
                self.strategyPic.image = image
            })
            strategyImageViewModel.downloadImageCommand.execute(nil)
        }
    }
}
