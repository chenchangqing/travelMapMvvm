//
//  VerifyViewController.swift
//  travelMap
//
//  Created by green on 15/6/18.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit
import ReactiveCocoa

class VerifyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var verifyCodeF: UITextField!
    @IBOutlet weak var passwordF: UITextField!
    @IBOutlet weak var timeB: UIButton!
    @IBOutlet weak var timeL: UILabel!
    
    // 在获取验证码后跳转时，请赋值
    var verifyViewModel:VerifyViewModel!
    
    // 校验信号
    var isValidVerifyCodeSignal:RACSignal!
    var isValidPwdSignal:RACSignal!
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        setup()
    }
    
    // MARK: - setup
    
    private func setup() {
        
        setupAllUIStyle()
        setupSignals()
        setupTextFields()
        setupRegisterButton()
        setupMessage()
        bindViewModel()
        setupCommands()
    }
    
    /**
     * 设置UIStyle
     */
    private func setupAllUIStyle() {
        
        view1.loginRadiusStyle()
        view2.loginRadiusStyle()
        view3.loginRadiusStyle()
        submitBtn.loginNoBorderStyle()
    }
    
    /**
     * 校验信号设置
     */
    private func setupSignals() {
        
        // 验证码是否有效信号
        isValidVerifyCodeSignal = verifyCodeF.rac_textSignal().mapAs {
            (text: NSString) -> NSNumber in
            
            return ValidHelper.isValidVerifyCode(text)
        }
        
        // 密码是否有效信号
        isValidPwdSignal = passwordF.rac_textSignal().mapAs({ (text:NSString) -> NSNumber in
            
            return ValidHelper.isValidPassword(text)
        })
    }
    
    /**
     * 文本输入设置
     */
    private func setupTextFields() {
        
        // 绑定验证输入框背景色
        isValidVerifyCodeSignal.mapAs { (isValid:NSNumber) -> UIColor in
            
            return isValid.boolValue ? UIColor.clearColor() : UITextField.warningBackgroundColor
        }.skip(1) ~> RAC(self.verifyCodeF,"backgroundColor")
        
        // 绑定密码输入框背景色
        isValidPwdSignal.mapAs { (isValid:NSNumber) -> UIColor in
            
            return isValid.boolValue ? UIColor.clearColor() : UITextField.warningBackgroundColor
        }.skip(1) ~> RAC(self.passwordF,"backgroundColor")
    }
    
    /**
     * 注册、发送验证按钮设置
     */
    private func setupRegisterButton() {
        
        let tempSignal = RACSignal.combineLatest([
            isValidVerifyCodeSignal,
            isValidPwdSignal,
            self.verifyViewModel.commitVerifyCodeCommand.executing,
            self.verifyViewModel.registerUserCommand.executing,
            self.verifyViewModel.registerViewModel.sendVerityCodeCommand.executing
        ]).mapAs({ (tuple: RACTuple) -> NSNumber in
                
            let first   = tuple.first as! Bool
            let second  = tuple.second as! Bool
            let third   = tuple.third as! Bool
            let fourth  = tuple.fourth as! Bool
            let fifth   = tuple.fifth as! Bool
            
            let enabled = first && second && !third && !fourth && !fifth
            
            return enabled
        })
        
        tempSignal ~> RAC(submitBtn,"enabled")
        tempSignal.mapAs { (enabled:NSNumber) -> UIColor in
            
            return enabled.boolValue ? UIButton.defaultBackgroundColor : UIButton.enabledBackgroundColor
        } ~> RAC(submitBtn,"backgroundColor")
        
        // 事件
        submitBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (any:AnyObject!) -> Void in
            self.view.endEditing(true)
            
            self.verifyViewModel.commitVerifyCodeCommand.execute(nil)
        }
        
        timeB.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (any:AnyObject!) -> Void in
            
            self.view.endEditing(true)
            self.verifyViewModel.registerViewModel.sendVerityCodeCommand.execute(nil)
        }
    }
    
    /**
     * 提示设置
     */
    private func setupMessage() {
        
        RACSignal.combineLatest([
            self.verifyViewModel.commitVerifyCodeCommand.executing,
            self.verifyViewModel.registerUserCommand.executing,
            self.verifyViewModel.registerViewModel.sendVerityCodeCommand.executing
            ,RACObserve(self.verifyViewModel, "msg")
        ]).subscribeNextAs { (tuple: RACTuple) -> () in
            
            let isLoading = tuple.first as! Bool || tuple.second as! Bool || tuple.third as! Bool
            let msg  = tuple.fourth as! String
            
            if isLoading {
                
                self.showHUDIndicator()
            } else {
                
                if msg.isEmpty {
                    
                    self.hideHUD()
                }
            }
            
            if !msg.isEmpty {
                
                self.showHUDErrorMessage(msg)
            }
        }
    }
    
    /**
     * 绑定View model
     */
    private func bindViewModel() {
        
        // 时时更新loginViewModel的验证码、密码
        verifyCodeF.rac_textSignal() ~> RAC(self.verifyViewModel, "verifyCode")
        passwordF.rac_textSignal() ~> RAC(self.verifyViewModel, "password")
        
        // 绑定时间按钮、text信息
        RACObserve(self.verifyViewModel, "timeButtonHidden") ~> RAC(self.timeB,"hidden")
        RACObserve(self.verifyViewModel, "timeLableText") ~> RAC(self.timeL,"text")
        RACObserve(self.verifyViewModel, "timeLableTextHidden") ~> RAC(self.timeL,"hidden")
        
    }
    
    /**
     * 命令设置
     */
    private func setupCommands() {
        
        // 验证验证码命令设置
        self.verifyViewModel.commitVerifyCodeCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
            }, error: { (error:NSError!) -> Void in
                
                self.verifyViewModel.msg = error.localizedDescription
            }, completed: { () -> Void in
                
                // 执行注册命令
                self.verifyViewModel.msg = kMsgCheckVerifyCodeSuccess
                self.verifyViewModel.registerUserCommand.execute(nil)
            })
        }
        
        // 手机注册命令设置
        self.verifyViewModel.registerUserCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
            }, error: { (error:NSError!) -> Void in
                
                self.verifyViewModel.msg = error.localizedDescription
            }, completed: { () -> Void in
                
                // 执行跳转
                self.verifyViewModel.msg = kMsgRegisterSuccess
                self.performSegueWithIdentifier(kSegueFromVerifyViewControllerToLoginViewController, sender: nil)
            })
        }
        
        // 重发验证码命令设置
        self.verifyViewModel.registerViewModel.sendVerityCodeCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).subscribeNext({ (any:AnyObject!) -> Void in
                
            }, error: { (error:NSError!) -> Void in
                
                if let error = error as? SMS_SDKError {
                    
                    self.verifyViewModel.msg = "\(error.code),\(error.errorDescription)"
                } else {
                    
                    self.verifyViewModel.msg = error.localizedDescription
                }
            }, completed: { () -> Void in
                
                // 提示发送成功
                self.verifyViewModel.msg = kMsgSendVerifyCodeSuccess
            })
        }
    }
}
