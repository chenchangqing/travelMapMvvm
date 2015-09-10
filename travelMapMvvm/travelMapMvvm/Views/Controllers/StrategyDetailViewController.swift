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
    
    @IBOutlet weak var strategyDetailView   : UITextView!
    @IBOutlet weak var textHeightConstraint : NSLayoutConstraint!
    
    var strategyModel : StrategyModel!  // 攻略实体

    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    // MARK: - SETUP
    
    private func setup() {
        
        setupRightButtons()         // 初始化详情、收藏按钮
        setupStrategyDetailView()   // 初始化攻略文本
    }
    
    /**
     * 初始化详情、收藏按钮
     */
    private func setupRightButtons() {
        
        let detailButton = UIBarButtonItem(title: "详情", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        
        let collectButton = UIBarButtonItem(title: "收藏", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        
        self.navigationItem.rightBarButtonItems = [detailButton,collectButton]
    }
    
    /**
     * 初始化攻略文本
     */
    private func setupStrategyDetailView() {
        
        // 标题
        let strategyTitleString      = strategyModel.title != nil ? strategyModel.title! : ""
        
        // 创建时间
        let strategyCreateTimeString = (strategyModel.createTime != nil ? strategyModel.createTime! : "")
        
        // 喜欢人数
        let strategyLikeNumberString = strategyModel.likeNumber != nil ? "  [\(strategyModel.likeNumber!)人喜欢]" : ""
        
        // 详细信息
        let strategyContentString    = strategyModel.desc != nil ? strategyModel.desc! : ""
        
        // 组装文本
        let contentString = "<color value=\"blue\"><font size=\"21\">\(strategyTitleString)</font></color><br/><br/><font size=\"14\">\(strategyCreateTimeString)\(strategyLikeNumberString)</font><br/><br/><font size=\"14\">\(strategyContentString)\(strategyContentString)</font>"
        
        let attributedString = GONMarkupParserManager.sharedParser().attributedStringFromString(contentString)
        self.strategyDetailView.attributedText = attributedString
        
        // 调整高度
        let textViewWidth = UIScreen.mainScreen().bounds.width - 16
        let textViewMaxH = UIScreen.mainScreen().bounds.height - 64/** 导航+20 **/ - 56/** 收起按钮上下边距+自身高度 **/
        var textViewHeight = self.strategyDetailView.height(textViewWidth)
        textViewHeight = textViewHeight > textViewMaxH ? textViewMaxH : textViewHeight
        
        self.textHeightConstraint.constant = textViewHeight
    }
}
