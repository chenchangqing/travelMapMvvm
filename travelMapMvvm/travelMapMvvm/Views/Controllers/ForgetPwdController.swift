//
//  ForgetPwdController.swift
//  travelMap
//
//  Created by green on 15/6/19.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit
import MBProgressHUD
import ReactiveCocoa

class ForgetPwdController: UIViewController, KeyboardProcessProtocol {

    @IBOutlet weak var containerV: UIView!
    @IBOutlet weak var sureBtn: UIButton!
    @IBOutlet weak var sendVerifyCodeBtn: UIButton!
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    @IBOutlet weak var telF: UITextField!
    @IBOutlet weak var codeF: UITextField!
    @IBOutlet weak var pwdF: UITextField!
    @IBOutlet weak var pwdF2: UITextField!
    
    @IBOutlet weak var scrollV: UIScrollView!
    
    private var forgetPwdViewModel = ForgetPwdViewModel()
    
    var scrollView:UIScrollView {
        
        get {
            return self.scrollV
        }
    }
    var activeField: UITextField?
    
    // MARK: - 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.registerKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.cancelKeyboardNotification()
    }
    
    // MARK: -
    
    private func setup() {
        
        setupAllUIStyle()
        bindViewModel()
        setupMessage()
        setupEvent()
        setupCommand()
    }
    
    /**
     * 设置UIStyle
     */
    private func setupAllUIStyle() {
        
        containerV.loginRadiusStyle()
        sureBtn.loginNoBorderStyle()
    }
    
    /**
     * 绑定view model
     */
    private func bindViewModel() {
        
        telF.rac_textSignal()   ~> RAC(forgetPwdViewModel,"telephone")
        pwdF.rac_textSignal()   ~> RAC(forgetPwdViewModel,"password")
        pwdF2.rac_textSignal()  ~> RAC(forgetPwdViewModel,"password2")
        codeF.rac_textSignal()  ~> RAC(forgetPwdViewModel,"verifyCode")
        
        RACObserve(forgetPwdViewModel, "sendVerifyCodeBtnEnabled") ~> RAC(sendVerifyCodeBtn,"enabled")
        RACObserve(forgetPwdViewModel, "sendVerifyCodeBtnBgColor") ~> RAC(sendVerifyCodeBtn,"backgroundColor")
        RACObserve(forgetPwdViewModel, "submitBtnEnabled") ~> RAC(sureBtn,"enabled")
        RACObserve(forgetPwdViewModel, "submitBtnBgColor") ~> RAC(sureBtn,"backgroundColor")
        
        RACObserve(self.forgetPwdViewModel,"telephoneFieldBgColor")    ~> RAC(telF,  "backgroundColor")
        RACObserve(self.forgetPwdViewModel,"verifyCodeFieldBgColor")   ~> RAC(codeF, "backgroundColor")
        RACObserve(self.forgetPwdViewModel,"passwordFieldBgColor")     ~> RAC(pwdF,  "backgroundColor")
        RACObserve(self.forgetPwdViewModel,"password2FieldBgColor")    ~> RAC(pwdF2, "backgroundColor")
    }
    
    /**
     * 成功失败提示
     */
    private func setupMessage() {
        
        RACSignal.combineLatest([
            forgetPwdViewModel.sendVerityCodeCommand.executing,
            forgetPwdViewModel.modifyPwdCommand.executing,
            forgetPwdViewModel.commitVerifyCodeCommand.executing,
            RACObserve(forgetPwdViewModel, "failureMsg"),
            RACObserve(forgetPwdViewModel, "successMsg")
        ]).subscribeNextAs { (tuple: RACTuple) -> () in
            
            let isLoading   = tuple.first as! Bool || tuple.second as! Bool || tuple.third as! Bool
            
            let failureMsg  = tuple.fourth as! String
            let successMsg  = tuple.fifth as! String
            
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
        
        // 发送验证码
        sendVerifyCodeBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (any:AnyObject!) -> Void in
            
            self.view.endEditing(true)
            self.forgetPwdViewModel.sendVerityCodeCommand.execute(nil)
        }
        
        // 修改密码
        sureBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (any:AnyObject!) -> Void in
            
            self.view.endEditing(true)
            self.forgetPwdViewModel.commitVerifyCodeCommand.execute(nil)
        }
    }
    
    /**
     * 命令设置
     */
    private func setupCommand() {
        
        // 发送验证码命令设置
        self.forgetPwdViewModel.sendVerityCodeCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
            }, error: { (error:NSError!) -> Void in
                
                if let error = error as? SMS_SDKError {
                    
                    self.forgetPwdViewModel.failureMsg = "\(error.code),\(error.errorDescription)"
                } else {
                    
                    self.forgetPwdViewModel.failureMsg = error.localizedDescription
                }
            }, completed: { () -> Void in
                    
                // 提示发送成功
                self.forgetPwdViewModel.successMsg = kMsgSendVerifyCodeSuccess
            })
        }
        
        // 验证验证码命令设置
        self.forgetPwdViewModel.commitVerifyCodeCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
            }, error: { (error:NSError!) -> Void in
                
                self.forgetPwdViewModel.failureMsg = error.localizedDescription
            }, completed: { () -> Void in
                
                // 提示验证成功
                self.forgetPwdViewModel.successMsg = kMsgCheckVerifyCodeSuccess
                
                // 开始修改密码
                self.forgetPwdViewModel.modifyPwdCommand.execute(nil)
            })
        }
        
        // 修改密码命令设置
        self.forgetPwdViewModel.modifyPwdCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
            }, error: { (error:NSError!) -> Void in
                
                self.forgetPwdViewModel.failureMsg = error.localizedDescription
            }, completed: { () -> Void in
                
                // 提示密码修改成功
                self.forgetPwdViewModel.successMsg = kMsgModifyPwdSuccess
            })
        }
    }
}
