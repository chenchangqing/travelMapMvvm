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
            visiteNumL.text    = "\(viewModel.visitNumber)"
            authorNameL.text   = viewModel.author
            
            // 加载小编头像
            if !self.loadLocalAuthorPic(viewModel) {
                
                self.loadNetAuthorPic(viewModel)
            }
            
            // 加载攻略图片
            if !self.loadLocalStrategyPic(viewModel) {
                
                self.loadNetStrategyPic(viewModel)
            }
            
        }
    }
    
    // MARK: - 图片加载
    
    /**
     * 内存加载小编图片
     */
    private func loadLocalAuthorPic(viewModel:StrategyModel) -> Bool{
        
        if let request = viewModel.requestAuthorPic {
            
            if let image = UIImageView.sharedImageCache().cachedImageForRequest(request) {
                
                authorHeadC.image = image
                return true
            }
        }
        return false
    }
    
    /**
     * 从内存加载攻略图片
     */
    private func loadLocalStrategyPic(viewModel:StrategyModel) -> Bool{
        
        if let request = viewModel.requestStrategyPic {
            
            if let image = UIImageView.sharedImageCache().cachedImageForRequest(request) {
                
                strategyPic.image = image
                return true
            }
        }
        return false
    }
    
    /**
     * 网络加载小编头像
     */
    private func loadNetAuthorPic(viewModel:StrategyModel) {
        
        viewModel.downloadAuthorPicImageWithUrl()?.deliverOn(RACScheduler.mainThreadScheduler()).subscribeNextAs({ (result:ResultModel) -> () in
            
            if let image=result.data as? UIImage {
                
                self.authorHeadC.image = image
            }
        })
    }
    
    /**
     * 网络加载攻略图片
     */
    private func loadNetStrategyPic(viewModel:StrategyModel) {
        
        viewModel.downloadStrategyPicImageWithUrl()?.deliverOn(RACScheduler.mainThreadScheduler()).subscribeNextAs({ (result:ResultModel) -> () in
            
            self.strategyPic.image = result.data as? UIImage
        })
    }
}
