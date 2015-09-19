//
//  Constant.h
//  travelMapMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//


// 第三方
#define MOB_SMSSDK_APPKEY           @"82972bfafffe"
#define MOB_SMSSDK_APPSECRET        @"ef9f8dd9a44c94028de083a240585170"

#define SINA_APPKEY                 @"2150907278"
#define SINA_APPSECRET              @"cae8002730cc0c051f5ff87857980476"
#define SINA_REDIRECTURL            @"http://sns.whalecloud.com/sina2/callback"

#define QQ_APPKEY                   @"1104658111"
#define QQ_APPSECRET                @"pE1PIpyahSa4tBrl"

#define MOB_SHARESDK_APPKEY         @"86c8483eac7e"

// sever json key
#define kSuccess    @"success"
#define kMsg        @"msg"
#define kData       @"data"

// error
#define kErrorDomain @"com.city.go"

// segue
#define kSegueFromStrategyListViewControllerToFilterViewController @"FromStrategyListViewControllerToFilterViewController"
#define kSegueFromStrategyListViewControllerToDesViewController    @"FromStrategyListViewControllerToDesViewController"
#define kSegueFromFilterViewControllerToStrategyListViewController @"FromFilterViewControllerToStrategyListViewController"
#define kSegueFromDesViewControllerToStrategyListViewController    @"FromDesViewControllerToStrategyListViewController"
#define kSegueFromRegisterViewControllerToVerifyViewController @"FromRegisterViewControllerToVerifyViewController"
#define kSegueFromVerifyViewControllerToLoginViewController @"FromVerifyViewControllerToLoginViewController"
#define kSegueFromStrategyListViewControllerToStrategyDetailViewController @"FromStrategyListViewControllerToStrategyDetailViewController"
#define kSegueFromStrategyDetailViewControllerToPOIMapViewController @"FromStrategyDetailViewControllerToPOIMapViewController"
#define kSegueFromPOIMapViewControllerToPOIDetailViewController @"FromPOIMapViewControllerToPOIDetailViewController"
#define kSegueFromPOIDetailViewControllerToMoreCommentsController @"FromPOIDetailViewControllerToMoreCommentsController"
#define kSegueFromPOIDetailViewControllerToPOIContainerController @"FromPOIDetailViewControllerToPOIContainerController"
#define kSegueFromPOIContainerControllerToListPOITypeViewController @"FromPOIContainerControllerToListPOITypeViewController"
#define kSegueFromPOIContainerControllerToMapPOITypeViewController @"FromPOIContainerControllerToMapPOITypeViewController"

// operation key
#define kLoginUserKey @"loginUserKey"                                                           // 登录用户key(保存用户信息在NSUserDefaultStand)
#define kUpdateUserCompletionNotificationName @"updateUserCompletionNotificationName"           // 登录成功通知(比如侧边栏信息需要登录后刷新)
#define kLoginPageDefaultTelephone @"loginPageDefaultTelephone"                                 // 登录页面默认显示的手机号码
#define kPresentLoginPageActionNotificationName @"presentLoginPageNotificationName"             // 呈现登录页面通知
#define kPresentLoginPageActionExitLoginNotificationName @"presentLoginPageActionExitLoginNotificationName"           // 登录或退出通知
#define kHotSearchData @"hotSearchData"
#define kHistorySearchData @"historySearchData"

// text constant
#define kTextLoginAccount @"    登录帐号"
#define kTextExitAccount @"    退出帐号"
#define kTextSearchPlaceHolder            @"搜索地图、目的地......"
#define kTextHotSearch @"热门搜索"
#define kTextHistorySearch @"历史搜索"

// msg
#define kMsgLogined @"用户已经登录"
#define kMsgQQAuthFailure @"腾讯登录授权失败"
#define kMsgSinaAuthFailure @"新浪登录授权失败"
#define kMsgLoginSuccess @"登录成功"
#define kMsgSendVerifyCodeSuccess @"发送验证码成功"
#define kMsgCheckVerifyCodeSuccess @"校验验证码成功"
#define kMsgRegisterSuccess @"注册成功"
#define kMsgModifyPwdSuccess @"密码修改成功"
#define kMsgModifyUInfoSuccess @"用户信息修改成功"
#define kMsgUploadHeadImageSuccess @"上传头像成功"
#define kMsgStartLocation @"开始定位"
#define kMsgStopLocation @"停止定位"
#define kMsgAddedComment @"增加评论成功"


