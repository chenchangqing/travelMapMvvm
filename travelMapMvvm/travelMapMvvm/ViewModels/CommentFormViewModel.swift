//
//  CommentFormViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/14.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa
import ReactiveViewModel

class CommentFormViewModel: RVMViewModel {
    
    // MARK: - View Model
    
    var moreCommentsViewModel:MoreCommentsViewModel!
   
    // MARK: - Init
    
    init(moreCommentsViewModel:MoreCommentsViewModel) {
        super.init()
        
        self.moreCommentsViewModel = moreCommentsViewModel
    }
}
