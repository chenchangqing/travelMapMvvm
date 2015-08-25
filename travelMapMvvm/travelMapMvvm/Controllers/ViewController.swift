//
//  ViewController.swift
//  CJMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var selectionCollectionView: CJSelectionCollectionView!
    private var viewModel: QueryCategoryDataViewModelProtocol = QueryCategoryDataViewModel(fileName: "filter")
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - SETUP
    
    private func setup() {
        
        // 初始化 selectionCollectionView
        setupSelectionCollectionView()
    }
    
    private func setupSelectionCollectionView() {
        
        self.selectionCollectionView.dataSource = viewModel.dataSource
        selectionCollectionView.cellClicked = {cellModel in
            
            println(cellModel.title)
        }
    }

}

