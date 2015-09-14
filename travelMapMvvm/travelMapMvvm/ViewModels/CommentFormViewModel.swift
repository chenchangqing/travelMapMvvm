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
    
    // MARK: - 提示信息
    
    dynamic var failureMsg  : String = ""   // 操作失败提示
    dynamic var successMsg  : String = ""   // 操作失败提示
    
    // MARK: - View Model
    
    var moreCommentsViewModel:MoreCommentsViewModel!
    
    // MARK: - DataSource Protocol
    
    private let commentModelDataSourceProtocol = JSONCommentModelDataSource.shareInstance()
    
    // MARK: - Data From UI
    
    dynamic var content : String!    // 评论内容
    dynamic var rating  : NSNumber!  // 评分
    
    // MARK: - 新增评论命令
    
    var addCommentCommand: RACCommand!
   
    // MARK: - Init
    
    init(moreCommentsViewModel:MoreCommentsViewModel) {
        super.init()
        
        self.moreCommentsViewModel = moreCommentsViewModel
        
        setup()
    }
    
    // MARK: - Set Up
    
    private func setup() {
        
        setupCommands()
    }
    
    // MARK: - Set Up Commands
    
    private func setupCommands() {
        
        self.addCommentCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            let level = POILevelEnum.instance(self.rating.integerValue - 1)!
            return self.commentModelDataSourceProtocol.addPOIComment(self.content, level: level, poiId: self.moreCommentsViewModel.poiDetailViewModel.poiModel.poiId!).materialize()
        })
    }
}
