//
//  ModifyUInfoViewController.swift
//  travelMapMvvm
//
//  Created by green on 15/9/9.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ModifyUInfoViewController: UITableViewController {
    
    // MARK: - UI
    
    @IBOutlet private weak var headC    : GCircleControl!
    @IBOutlet private weak var nameF    : UITextField!
    @IBOutlet private weak var emailF   : UITextField!
    @IBOutlet private weak var telF     : UITextField!
    @IBOutlet private weak var modifyBtn: UIButton!
    
    // MARK: -
    
    var modifyUInfoViewModel    : ModifyUInfoViewModel!     // view model
    var imagePickerVC           : UIImagePickerController!  // 图片选择器

    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 查询最终登录用户
        self.modifyUInfoViewModel.leftViewModel.queryLoginUser()
    }
    
    // MARK: - setup
    
    private func setup() {
        
        bindViewModel()
        setupMessage()
        setupEvent()
        setupCommand()
        setupImagePickerVC()
    }
    
    /**
     * 绑定view model
     */
    private func bindViewModel() {
        
        nameF.rac_textSignal().skip(1) ~> RAC(modifyUInfoViewModel,"leftViewModel.loginUser.userName")
        emailF.rac_textSignal().skip(1)  ~> RAC(modifyUInfoViewModel,"leftViewModel.loginUser.email")
        telF.rac_textSignal().skip(1)  ~> RAC(modifyUInfoViewModel,"leftViewModel.loginUser.telephone")
        
        RACObserve(modifyUInfoViewModel.leftViewModel.loginUser,"telephone")   ~> RAC(telF,  "text")
        RACObserve(modifyUInfoViewModel.leftViewModel.loginUser,"email")       ~> RAC(emailF, "text")
        RACObserve(modifyUInfoViewModel.leftViewModel.loginUser,"userName")    ~> RAC(nameF, "text")
        
        RACObserve(modifyUInfoViewModel, "submitBtnEnabled") ~> RAC(modifyBtn,"enabled")
        RACObserve(modifyUInfoViewModel, "submitBtnBgColor") ~> RAC(modifyBtn,"backgroundColor")
        
        RACObserve(modifyUInfoViewModel,"userNameFieldBgColor")    ~> RAC(nameF,  "backgroundColor")
        RACObserve(modifyUInfoViewModel,"emailFieldBgColor")       ~> RAC(emailF, "backgroundColor")
        
        RACObserve(modifyUInfoViewModel.leftViewModel, "image") ~> RAC(headC,"image")
    }
    
    /**
     * 成功失败提示
     */
    private func setupMessage() {
        
        RACSignal.combineLatest([
            RACObserve(modifyUInfoViewModel, "failureMsg"),
            RACObserve(modifyUInfoViewModel, "successMsg"),
            modifyUInfoViewModel.uploadHeadImageCommand.executing,
            modifyUInfoViewModel.modifyUInfoCommand.executing
        ]).subscribeNextAs { (tuple: RACTuple) -> () in
            
            let failureMsg  = tuple.first as! String
            let successMsg  = tuple.second as! String
            
            let isLoading   = tuple.fourth as! Bool || tuple.third as! Bool
            
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
    
    /**
     * 事件设置
     */
    private func setupEvent() {
        
        modifyBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (any:AnyObject!) -> Void in
            
            self.view.endEditing(true)
            self.modifyUInfoViewModel.modifyUInfoCommand.execute(nil)
        }
        
        headC.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (any:AnyObject!) -> Void in
            
            let actionSheet = UIActionSheet(title: nil, delegate: nil, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "相册","拍照")
            
            actionSheet.rac_buttonClickedSignal().subscribeNextAs({ (index:NSNumber) -> () in
                
                if index.integerValue == 1 {
                    
                    // 相册
                    self.openPhotoLibrary()
                }
                
                if index.integerValue == 2 {
                    
                    // 拍照
                    self.openCamera()
                }
            })
            
            actionSheet.showInView(self.view)
        }
    }
    
    /**
     * 命令设置
     */
    private func setupCommand() {
        
        modifyUInfoViewModel.modifyUInfoCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
                // 更新view model
                self.modifyUInfoViewModel.leftViewModel.loginUser = any as? UserModel
            }, error: { (error:NSError!) -> Void in
                
                self.modifyUInfoViewModel.failureMsg = error.localizedDescription
            }, completed: { () -> Void in
                
                // 提示密码修改成功
                self.modifyUInfoViewModel.successMsg = kMsgModifyUInfoSuccess
            })
        }
        
        modifyUInfoViewModel.uploadHeadImageCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
                // 更新view model
                self.modifyUInfoViewModel.leftViewModel.loginUser = any as? UserModel
            }, error: { (error:NSError!) -> Void in
                
                self.modifyUInfoViewModel.failureMsg = error.localizedDescription
            }, completed: { () -> Void in
                
                // 提示上传头像成功
                self.modifyUInfoViewModel.successMsg = kMsgUploadHeadImageSuccess
            })
        }
    }
}
