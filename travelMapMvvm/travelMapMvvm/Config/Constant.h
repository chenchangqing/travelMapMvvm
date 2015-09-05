//
//  Constant.h
//  travelMapMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

// sever json key
#define kSuccess    @"success"
#define kMsg        @"msg"
#define kData       @"data"

// error
#define kErrorDomain @"com.city.go"

// segue
#define kSegueFromIndexViewControllerToFilterViewController @"FromIndexViewControllerToFilterViewController"
#define kSegueFromIndexViewControllerToDesViewController    @"FromIndexViewControllerToDesViewController"
#define kSegueFromFilterViewControllerToIndexViewController @"FromFilterViewControllerToIndexViewController"
#define kSegueFromDesViewControllerToIndexViewController    @"FromDesViewControllerToIndexViewController"

// user operation key
#define kLoginUserKey @"loginUserKey"                                                           // 登录用户key(保存用户信息在NSUserDefaultStand)
#define kUpdateUserCompletionNotificationName @"updateUserCompletionNotificationName"           // 登录成功通知(比如侧边栏信息需要登录后刷新)
#define kLoginPageDefaultTelephone @"loginPageDefaultTelephone"                                 // 登录页面默认显示的手机号码
#define kPresentLoginPageActionNotificationName @"presentLoginPageNotificationName"             // 呈现登录页面通知
#define kExitLoginNotificationName @"exitLoginNotificationName"                                 // 退出登录通知

// text constant
#define kTextLoginAccount @"    登录帐号"
#define kTextExitAccount @"    退出帐号"

// msg
#define kMsgLogined @"用户已经登录"
#define kMsgLoginSuccess @"登录成功"


