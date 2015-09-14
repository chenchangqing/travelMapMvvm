//
//  CommentCell.swift
//  travelMap
//
//  Created by green on 15/7/9.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit
import GONMarkupParser
import ReactiveCocoa

class CommentCell: UITableViewCell, ReactiveView {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var levelV: RatingBar!
    @IBOutlet weak var contentV: UITextView!
    @IBOutlet weak var headCircleV: GCircleControl!
    
    private var authorImageViewModel = ImageViewModel(urlString: nil)
    
    // MARK: - init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Observe
        RACObserve(authorImageViewModel, "image") ~> RAC(headCircleV,"image")
        
        self.rac_prepareForReuseSignal.subscribeNext { (any:AnyObject!) -> Void in
            
            self.headCircleV.image = UIImage()
        }
    }
    
    // MARK: - ReactiveView
    
    func bindViewModel(viewModel: AnyObject) {
        
        if let viewModel = viewModel as? CommentModel {
            
            userName.text = viewModel.author
            
            if let level=viewModel.level {
                
                self.levelV.rating = CGFloat(level.index+1)
            }
            
            contentV.attributedText    = GONMarkupParserManager.sharedParser().attributedStringFromString("<font size=\"14\">" + (viewModel.content == nil ? "" : "\(viewModel.content!)") + "</>")
            
            // 加载小编头像图片
            authorImageViewModel.urlString = viewModel.authorPicUrl
            authorImageViewModel.downloadImageCommand.execute(nil)
        }
    }

    /**
     * 计算cell高度
     */
    class func caculateCellHeight(comments: [CommentModel]) -> OrderedDictionary<CommentModel,NSNumber> {
        
        // 字典
        var commentsDic = OrderedDictionary<CommentModel,NSNumber>()
        
        // 计算高度
        let tempTextView = UITextView()
        for tuple in enumerate(comments) {
            
            tempTextView.attributedText = GONMarkupParserManager.sharedParser().attributedStringFromString("<font size=\"14\">" + (tuple.element.content == nil ? "" : "\(tuple.element.content!)") + "</>")
            let height = NSNumber(float: Float(tempTextView.height(UIScreen.mainScreen().bounds.width - 32) + 60))
            commentsDic[tuple.element] = height
        }
        return commentsDic
    }
}
