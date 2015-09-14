//
//  CommentFormController.swift
//  travelMapMvvm
//
//  Created by green on 15/9/14.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import ReactiveCocoa
import KGModal

class CommentFormController: UIViewController {
    
    // MARK: - UI
    
    @IBOutlet weak var levelV: RatingBar!
    @IBOutlet weak var poiPicV: UIImageView!
    @IBOutlet weak var poiNameL: UILabel!
    @IBOutlet weak var commentTextArea: UITextView!
    @IBOutlet weak var sureBtn: UIButton!
    
    @IBOutlet weak var placeHolder: UILabel!
    @IBOutlet weak var scrollV: UIScrollView!
    
    // MARK: - View Model
    
    var commentFormViewModel: CommentFormViewModel!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCommands()
        setupUI()
        bindViewModel()
        setupMessage()
    }
    
    // MARK: - 命令设置
    
    private func setupCommands() {
        
        commentFormViewModel.addCommentCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
                // 更新列表数据
                let commentModel = any as! CommentModel
                self.commentFormViewModel.moreCommentsViewModel.addedCommentModel = commentModel
                
            }, error: { (error:NSError!) -> Void in
                
                self.commentFormViewModel.failureMsg = error.localizedDescription
                
            }, completed: { () -> Void in
                
                KGModal.sharedInstance().hide()
            })
        }
    }
    
    // MARK: - 设置UI
    
    private func setupUI() {
        
        view.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds) * 0.8 , CGRectGetHeight(UIScreen.mainScreen().bounds) * 0.8)
        
        sureBtn.loginBorderStyle()
        
        // event
        self.sureBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (any:AnyObject!) -> Void in
            
            // 发出统一登录通知
            let paramObj = LoginPageParamModel(presentLoginPageCompletionCallback:{
                
                KGModal.sharedInstance().hide()
            },loginSuccessCompletionCallback: {
                
                // 登录之后新增
                self.commentFormViewModel.rating = self.levelV.rating
                self.commentFormViewModel.addCommentCommand.execute(nil)
                (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController!.showHUDMessage(kMsgAddedComment)
            })
            NSNotificationCenter.defaultCenter().postNotificationName(kPresentLoginPageActionNotificationName, object: paramObj, userInfo: nil)
        }
    }
    
    
    // MARK: - Bind View Model
    
    private func bindViewModel() {
        
        // POI 图片
        RACObserve(self, "commentFormViewModel.moreCommentsViewModel.poiDetailViewModel.poiImageViewModel.image") ~> RAC(poiPicV,"image")
        
        // POI 名称
        RACObserve(self, "commentFormViewModel.moreCommentsViewModel.poiDetailViewModel.poiModel.poiName") ~> RAC(poiNameL,"text")
        
        // POI 评分
        RACObserve(self, "commentFormViewModel.moreCommentsViewModel.poiDetailViewModel.poiModel").ignore(nil).map{ (poiModel:AnyObject!) -> AnyObject! in
            
            let poiModel = poiModel as! POIModel
            if let level = poiModel.level {
                
                return CGFloat(level.index+1)
            }
            return nil
        }.ignore(nil) ~> RAC(levelV,"rating")
        
        // 更新view model
        self.commentTextArea.rac_textSignal() ~> RAC(self.commentFormViewModel,"content")
        
        // 确认按钮背景色、是否可点击
        self.commentTextArea.rac_textSignal().mapAs { (text:NSString) -> NSNumber in
            
            return String(text).length > 0
        } ~> RAC(self.sureBtn,"enabled")
        
        self.commentTextArea.rac_textSignal().mapAs { (text:NSString) -> UIColor in
            
            return String(text).length > 0 ? UIButton.defaultBackgroundColor : UIButton.enabledBackgroundColor
        } ~> RAC(self.sureBtn,"backgroundColor")
        
        // placeholder
        self.commentTextArea.rac_textSignal().mapAs { (text:NSString) -> NSNumber in
            
            return String(text).length > 0
        }.subscribeNextAs { (isValid:NSNumber) -> () in
            
            if isValid.boolValue {
                
                self.placeHolder.text = ""
            } else {
                
                self.placeHolder.text = "点击添加文字..."
            }
        }
    }
    
    // MARKO: - Setup Message 成功失败提示 加载提示
    
    private func setupMessage() {
        
        RACSignal.combineLatest([
            RACObserve(commentFormViewModel, "failureMsg"),
            RACObserve(commentFormViewModel, "successMsg"),
            commentFormViewModel.addCommentCommand.executing
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
}
