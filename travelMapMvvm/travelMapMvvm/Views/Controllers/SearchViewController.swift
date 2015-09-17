//
//  SearchViewController.swift
//  travelMapMvvm
//
//  Created by green on 15/9/17.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import ReactiveCocoa

class SearchViewController: UIViewController,UISearchDisplayDelegate, UISearchBarDelegate {
    
    // MARK: - View Model
    
    let searchViewModel = SearchViewModel()
    
    // MARK: - SearchDisplayController
    
    var mySearchDisplayController: UISearchDisplayController!
    
    // MARK: - 选择控件
    
    @IBOutlet private weak var selectionCollectionView : CJSelectionCollectionView!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    // MARK: - Set Up
    
    private func setUp() {
        
        setUpSearchDisplayController()
        setUpCommands()
        setUpMessage()
        setUpSelectionCollectionView()
        
    }
    
    // MARK: - Set Up SearchDisplayController
    
    private func setUpSearchDisplayController() {
        
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.placeholder = kTextSearchPlaceHolder
        searchBar.sizeToFit()
        searchBar.translucent = false
        searchBar.delegate = self
    
        digui(searchBar) // 设置UISearchBarTextField
        
        
        mySearchDisplayController = UISearchDisplayController(searchBar: searchBar, contentsController: self)
        mySearchDisplayController.delegate = self
        mySearchDisplayController.displaysSearchBarInNavigationBar = true
        self.navigationItem.hidesBackButton = true
//        customSearchDisplayController.searchResultsDataSource = self
//        customSearchDisplayController.searchResultsDelegate = self
    }
    
    private func digui(view:UIView) {
        
        for item in enumerate(view.subviews) {
            
            let className = NSStringFromClass(item.element.classForCoder)
            
            if className == "UISearchBarTextField" {
                
                (item.element as! UIView).backgroundColor = ColorHelper.hexStringToUIColor("#e7e7e7")
                break;
            }
            
            if item.element.subviews.count > 0 {
                
                digui(item.element as! UIView)
            }
        }
    }
    
    // MARK: - Set Up Commands 
    
    private func setUpCommands() {
        
        searchViewModel.querySearchViewDataCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
                // 更新数据
                self.searchViewModel.searchViewData     = any as! DataSource
                self.selectionCollectionView.dataSource = self.searchViewModel.searchViewData.dataSource
                self.selectionCollectionView.reloadData()
                
            }, error: { (error:NSError!) -> Void in
                
            }, completed: { () -> Void in
                
            })
        }
    }
    
    // MARK: - Set Up Message 
    
    private func setUpMessage() {
        
        RACSignal.combineLatest([
            RACObserve(searchViewModel, "failureMsg"),
            RACObserve(searchViewModel, "successMsg"),
            searchViewModel.querySearchViewDataCommand.executing
        ]).subscribeNextAs { (tuple: RACTuple) -> () in
            
            let failureMsg  = tuple.first as! String
            let successMsg  = tuple.second as! String
            
            let isLoading   = tuple.third as! Bool
            
            if isLoading {
                
                self.showHUDIndicator()
            } else {
                
                if failureMsg.isEmpty && successMsg.isEmpty {
                    
                    self.hideHUD()
                }
            }
            
            if !failureMsg.isEmpty {
                
                self.showHUDErrorMessage(failureMsg)
            }
            
            if !successMsg.isEmpty {
                
                self.showHUDMessage(successMsg)
            }
        }
    }
    
    // MARK: - Set Up SelectionCollectionView
    
    private func setUpSelectionCollectionView() {
        
        self.searchViewModel.active = true
    }
    
    // MARK: - UISearchDisplayDelegate
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        return true
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        self.back(searchBar)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchViewModel.keyword = searchText
    }

}
