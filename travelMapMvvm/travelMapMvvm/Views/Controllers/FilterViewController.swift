//
//  FilterViewController.swift
//  travelMap
//
//  Created by green on 15/7/3.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    // 数据源
    private var dataSource = OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>()
    
    // 选择控件
    @IBOutlet private weak var selectionCollectionView : CJSelectionCollectionView!
    
    // 重置按钮
    @IBOutlet private weak var resetBtn: UIButton!
    
    // 确定按钮
    @IBOutlet private weak var okBtn: UIButton!
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - setup
    
    private func setup() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 初始化数据源
        setupDataSource()
        
        // 初始化选择控件
        setupSelectionCollectionView()
        
        // 初始化按钮
        setupButtons()
    }
    
    /**
     * 初始化数据源
     */
    private func setupDataSource() {
        
        // 旅游月份信息
        let monthHeaderModel    = CJCollectionViewHeaderModel(
            icon: "home_btn_cosmetic",
            title: "旅游月份",
            type: .MultipleChoice,
            isExpend: true,
            isShowClearButton: false,
            height: 38)
        var monthCellModelArray = [CJCollectionViewCellModel]()
        
        for month in MonthEnum.allValues {
            
            monthCellModelArray.append(CJCollectionViewCellModel(icon: nil, title: month.rawValue))
        }
        
        // 攻略主题信息
        let strategyThemeHeaderModel    = CJCollectionViewHeaderModel(
            icon: "home_btn_cosmetic",
            title: "主题", type: .MultipleChoice,
            isExpend: true,
            isShowClearButton: false,
            height: 38)
        var strategyThemeCellModelArray = [CJCollectionViewCellModel]()
        
        for strategyTheme in StrategyThemeEnum.allValues {
            
            strategyThemeCellModelArray.append(CJCollectionViewCellModel(icon: nil, title: strategyTheme.rawValue))
        }
        
        // 攻略分类信息
        let strategyTypeHeaderModel    = CJCollectionViewHeaderModel(
            icon: "home_btn_cosmetic",
            title: "分类",
            type: .MultipleChoice,
            isExpend: true,
            isShowClearButton: false,
            height: 38)
        var strategyTypeCellModelArray = [CJCollectionViewCellModel]()
        
        for strategyType in StrategyTypeEnum.allValues {
            
            strategyTypeCellModelArray.append(CJCollectionViewCellModel(icon: nil, title: strategyType.rawValue))
        }
        
        // 初始化dataSource
        dataSource[monthHeaderModel]            = monthCellModelArray
        dataSource[strategyThemeHeaderModel]    = strategyThemeCellModelArray
        dataSource[strategyTypeHeaderModel]     = strategyTypeCellModelArray
    }
    
    /**
     * 初始化选择控件
     */
    private func setupSelectionCollectionView() {
        
        // 设置选择控件数据源
        selectionCollectionView.dataSource = dataSource
        
    }
    
    /**
     * 初始化按钮
     */
    private func setupButtons() {
        
        // 设置按钮边颜色
        let layerRectHorizontal   = CGRectMake(0, 0, CGRectGetWidth(view.bounds)/2, 0.5)
        let layerRectVertical     = CGRectMake(0, 0, 0.5, 40)
        let layerColor            = UIColor.lightGrayColor().CGColor
        okBtn.addSubLayerWithFrame(layerRectHorizontal, color: layerColor)
        resetBtn.addSubLayerWithFrame(layerRectHorizontal, color: layerColor)
        resetBtn.addSubLayerWithFrame(layerRectVertical, color: layerColor)
        
        // ok event
        okBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (any:AnyObject!) -> Void in
            
            println(self.selectionCollectionView.resultDictionary)
            self.performSegueWithIdentifier(kSegueFromFilterViewControllerToIndexViewController, sender: nil)
        }
        
        // reset event
        resetBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (any:AnyObject!) -> Void in
            
            self.selectionCollectionView.reset()
        }
        
    }
}
