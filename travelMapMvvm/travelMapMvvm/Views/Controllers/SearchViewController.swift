//
//  SearchViewController.swift
//  travelMapMvvm
//
//  Created by green on 15/9/17.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UISearchDisplayDelegate {
    
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
        searchBar.showsCancelButton = false
        searchBar.placeholder = kTextSearchPlaceHolder
        searchBar.sizeToFit()
        searchBar.translucent = true
        
        mySearchDisplayController = UISearchDisplayController(searchBar: searchBar, contentsController: self)
//        customSearchDisplayController.searchResultsDataSource = self
//        customSearchDisplayController.searchResultsDelegate = self
        mySearchDisplayController.delegate = self
        mySearchDisplayController.displaysSearchBarInNavigationBar = true
        mySearchDisplayController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_btn"), style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("back:"))
    }
    
    // MARK: - UISearchDisplayDelegate
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        return true
    }

}
