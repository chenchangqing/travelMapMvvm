//
//  StrategyDetailViewController.swift
//  travelMapMvvm
//
//  Created by green on 15/9/9.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit

class StrategyDetailViewController: UIViewController {
    
    var strategyModel : StrategyModel!  // 攻略实体

    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    // MARK: - SETUP
    
    private func setup() {
        
        setupRightButtons() // 初始化详情、收藏按钮
    }
    
    /**
     * 初始化详情、收藏按钮
     */
    private func setupRightButtons() {
        
        let detailButton = UIBarButtonItem(title: "详情", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        
        let collectButton = UIBarButtonItem(title: "收藏", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        
        self.navigationItem.rightBarButtonItems = [detailButton,collectButton]
    }
}
