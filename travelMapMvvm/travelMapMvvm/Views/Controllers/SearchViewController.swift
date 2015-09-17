//
//  SearchViewController.swift
//  travelMapMvvm
//
//  Created by green on 15/9/17.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UISearchDisplayDelegate, UISearchBarDelegate {
    
    // MARK: - SearchDisplayController
    
    var mySearchDisplayController: UISearchDisplayController!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    // MARK: - Set Up
    
    private func setUp() {
        
        setUpSearchDisplayController()
        
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
    
    // MARK: - UISearchDisplayDelegate
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        return true
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        self.back(searchBar)
    }

}
