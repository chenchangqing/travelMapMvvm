//
//  SearchResultViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/19.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveViewModel

class SearchResultViewModel: RVMViewModel {
    
    // MARK: - Key Word
    
    dynamic var keyword : String = ""
    
    // MARK: - Init
    
    override init() {
        
        super.init()
    }
}
