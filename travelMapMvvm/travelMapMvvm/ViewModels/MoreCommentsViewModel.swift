//
//  MoreCommentsViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/14.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa
import ReactiveViewModel

class MoreCommentsViewModel: RVMViewModel {
    
    // MARK: - 提示信息
    
    dynamic var failureMsg  : String = ""   // 操作失败提示
    dynamic var successMsg  : String = ""   // 操作失败提示
    
    // MARK: - data
    
    var comments = OrderedDictionary<CommentModel,NSNumber>()
    var poiId:String!
    
    // MARK: - 上拉加载命令/下拉刷新命令
    
    var refreshCommand: RACCommand!
    var loadmoreCommand: RACCommand!
    
    private let commentModelDataSourceProtocol = JSONCommentModelDataSource.shareInstance()
    
    // MARK: - Init
    
    init(poiId:String) {
        super.init()
        
        self.poiId = poiId
        
        setup()
    }
    
    // MARK: - SET UP
    
    private func setup() {
        
        setupCommands()
    }
    
    // MARK: - Initial Commands
    
    private func setupCommands() {
        
        refreshCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            return self.commentModelDataSourceProtocol.queryPOICommentList(self.poiId, rows: 3, startId: nil).materialize()
        })
        
        loadmoreCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            return self.commentModelDataSourceProtocol.queryPOICommentList(self.poiId, rows: 3, startId: nil).materialize()
        })
    }
   
}
