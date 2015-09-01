//
//  FilterViewController.swift
//  travelMap
//
//  Created by green on 15/7/3.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import ReactiveCocoa

class FilterViewController: UIViewController {
    
    // viewModel
    private var filterViewModel = FilterViewModel()
    
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
        
        // 查询数据
        filterViewModel.filterSelectionDicSearch.execute(nil)
        
        // 提示动画
        self.indicatorView.startAnimation()
    }
    
    // MARK: - setup
    
    private func setup() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        
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
        RACObserve(filterViewModel, "dataSource").doNext { (any:AnyObject!) -> Void in
            
            // 有数据了就停止动画
            self.indicatorView.stopAnimation()
        }.subscribeNextAs { (dataSource:DataSource) -> () in
            
            self.selectionCollectionView.dataSource = dataSource.dataSource
            self.selectionCollectionView.reloadData()
        }
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
