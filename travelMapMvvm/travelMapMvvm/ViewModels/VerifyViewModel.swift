//
//  VerifyViewModel.swift
//  travelMapMvvm
//
//  Created by green on 15/9/8.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa
import ReactiveViewModel

class VerifyViewModel: RVMViewModel {

    private let userModelDataSourceProtocol = JSONUserModelDataSource.shareInstance()
    var registerViewModel: RegisterViewModel!
    
    dynamic var timeButtonHidden = true    // 重发验证码按钮是否隐藏
    dynamic var timeLableTextHidden = false // 是否现实时间
    dynamic var timeLableText = "60秒"      // 倒计时Text
    dynamic var msg = ""                    // 提示信息
    dynamic var verifyCode = ""             // 验证码
    dynamic var password = ""               // 密码
    
    var commitVerifyCodeCommand: RACCommand!    // 验证验证码命令
    var registerUserCommand: RACCommand!        // 手机注册命令
    
    // 定时器 用于更新发送按钮及倒计时text
    var count = 0
    var timer1: NSTimer!
    var timer2: NSTimer!
    
    init(registerViewModel:RegisterViewModel) {
        super.init()
        
        // 初始化registerViewModel 用户重发短信
        self.registerViewModel = registerViewModel
        
        // 定时器
        timer1 = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTimeLabelText"), userInfo: nil, repeats: true)
        timer2 = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: Selector("showTimeButtonHidden"), userInfo: nil, repeats: true)
        
        // 初始化命令
        commitVerifyCodeCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            return registerViewModel.smsDataSourceProtocol.commitVerityCode(self.verifyCode).materialize()
        })
        
        registerUserCommand = RACCommand(signalBlock: { (any:AnyObject!) -> RACSignal! in
            
            return self.userModelDataSourceProtocol.register(self.registerViewModel.telephone, password: self.password).materialize()
        })
    }
    
    // MARK: - 更新时间 UI
    
    func updateTimeLabelText() {
        
        count++
        if count >= 60 {
            
            timer1.invalidate()
            return
        }
        timeLableText = "\(60-count)秒"
    }
    
    func showTimeButtonHidden() {
        
        timeLableTextHidden = true
        timeButtonHidden = false
        timer2.invalidate()
    }
}
