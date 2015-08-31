//
//  DesViewController.swift
//  travelMap
//
//  Created by green on 15/7/5.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit

class DesViewController: UIViewController {
    
    // viewModel
    private var desViewModel : DesViewModel!
    
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
        
        // 初始化viewModel
        desViewModel = DesViewModel(cellWidth: CGRectGetWidth(UIScreen.mainScreen().bounds) - selectionCollectionView.collectionViewLeftMargin - selectionCollectionView.collectionViewRightMargin)
        
        // 初始化选择控件
        setupSelectionCollectionView()
        
        // 初始化按钮
        setupButtons()
    }
    
    /**
     * 初始化选择控件
     */
    private func setupSelectionCollectionView() {
        
        // 设置选择控件数据源
        selectionCollectionView.dataSource = desViewModel.desSelectionDic
        
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
            self.performSegueWithIdentifier(kSegueFromDesViewControllerToIndexViewController, sender: nil)
        }
        
        // reset event
        resetBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (any:AnyObject!) -> Void in
            
            self.selectionCollectionView.reset()
        }
        
    }
}
