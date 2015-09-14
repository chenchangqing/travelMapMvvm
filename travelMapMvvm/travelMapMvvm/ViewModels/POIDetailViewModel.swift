//
//  POIDetailViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/13.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa
import ReactiveViewModel
import GONMarkupParser

class POIDetailViewModel: RVMViewModel {
    
    // MARK: - 提示信息
    
    dynamic var failureMsg  : String = ""   // 操作失败提示
    dynamic var successMsg  : String = ""   // 操作失败提示
   
    // MARK: - POI IMAGE
    
    var poiImageViewModel = ImageViewModel(urlString: nil, defaultImage:UIImage(named: "defaultImage.jpg")!)
    
    // MARK: - POI Model / Comment Model
    
    dynamic var poiModel : POIModel!
    dynamic var comments = [CommentModel]()
    
    // MARK: - Search Comments Command

    var searchCommentsCommand: RACCommand!
    private let commentModelDataSourceProtocol = JSONCommentModelDataSource.shareInstance()
    
    // MARK: - INIT
    
    init(poiModel:POIModel) {
        
        self.poiModel = poiModel
        
        super.init()
        
        RACObserve(self.poiModel, "poiPicUrl").ignore(nil).subscribeNext { (poiPicUrl:AnyObject?) -> () in
            
            self.poiImageViewModel.urlString = poiPicUrl as? String
            self.poiImageViewModel.downloadImageCommand.execute(nil)
        }
        
        searchCommentsCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            if let poiId=poiModel.poiId {
                
                return self.commentModelDataSourceProtocol.queryPOICommentList(poiId, rows: 3, startId: nil).materialize()
            } else {
                
                return RACSignal.empty()
            }
        })
        
    }
    
    // MARK: -
    
    /**
     * 排版攻POI详情数据
     */
    func getPOITextViewData(poiModel:POIModel) -> (
        poiDesc:NSMutableAttributedString,
        poiAddress:NSMutableAttributedString,
        openTime:NSMutableAttributedString,
        poiTiket:NSMutableAttributedString
    ) {
        
        // 简介
        let poiDesc    = "<font size=\"14\">简介："+(poiModel.desc != nil ? poiModel.desc! : "")+"</>"
        let poiDescAttributedString = GONMarkupParserManager.sharedParser().attributedStringFromString(poiDesc)
        
        // 地址
        let poiAddress = "<font size=\"14\">地址："+(poiModel.address != nil ? poiModel.address! : "")+"</>"
        let poiAddressAttributedString = GONMarkupParserManager.sharedParser().attributedStringFromString(poiAddress)
        
        // 开放时间
        let openTime   = "<font size=\"14\">开放时间："+(poiModel.openTime != nil ? "  [\(poiModel.openTime!)人喜欢]" : "")+"</>"
        let openTimeAttributedString = GONMarkupParserManager.sharedParser().attributedStringFromString(openTime)
        
        // 门票
        let poiTiket   = "<font size=\"14\">门票："+(poiModel.ticketPrice != nil ? poiModel.ticketPrice! : "")+"</>"
        let poiTiketAttributedString = GONMarkupParserManager.sharedParser().attributedStringFromString(poiTiket)
        
        return (poiDescAttributedString,poiAddressAttributedString,openTimeAttributedString,poiTiketAttributedString)
    }
}
