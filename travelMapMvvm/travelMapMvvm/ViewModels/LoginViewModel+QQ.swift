//
//  LoginViewModel+QQ.swift
//  travelMapMvvm
//
//  Created by green on 15/9/6.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation

extension LoginViewModel : TencentSessionDelegate{
    
    // MARK: - TencentSessionDelegate
    
    func tencentDidLogin() {
        
        // 授权后，开始登录
        self.qqTencentDidLoginCommand.execute(nil)
    }
    
    func tencentDidNotLogin(canceled:Bool) {
        
    }
    
    func tencentDidNotNetWork() {
        
    }
    
    func tencentDidLogout() {
        
    }
    func tencentNeedPerformIncrAuth(tencentOAuth: TencentOAuth!, withPermissions permissions: [AnyObject]!) -> Bool {
        
        return true
    }
    func tencentNeedPerformReAuth(tencentOAuth: TencentOAuth!) -> Bool {
        
        return true
    }
    func tencentDidUpdate(tencentOAuth: TencentOAuth!) {
        
    }
    func tencentFailedUpdate(reason: UpdateFailType) {
        
    }
    func getUserInfoResponse(response: APIResponse!) {
        
        
    }
    func getListAlbumResponse(response: APIResponse!) {
        
    }
    func getListPhotoResponse(response: APIResponse!) {
        
    }
    func checkPageFansResponse(response: APIResponse!) {
        
    }
    func addShareResponse(response: APIResponse!) {
        
    }
    func addAlbumResponse(response: APIResponse!) {
        
    }
    func uploadPicResponse(response: APIResponse!) {
        
    }
    func addOneBlogResponse(response: APIResponse!) {
        
    }
    func addTopicResponse(response: APIResponse!) {
        
    }
    func setUserHeadpicResponse(response: APIResponse!) {
        
    }
    func getVipInfoResponse(response: APIResponse!) {
        
    }
    func getVipRichInfoResponse(response: APIResponse!) {
        
    }
    func matchNickTipsResponse(response: APIResponse!) {
        
    }
    func getIntimateFriendsResponse(response: APIResponse!) {
        
    }
    func sendStoryResponse(response: APIResponse!) {
        
    }
    func responseDidReceived(response: APIResponse!, forMessage message: String!) {
        
    }
    func tencentOAuth(tencentOAuth: TencentOAuth!, didSendBodyData bytesWritten: Int, totalBytesWritten: Int, totalBytesExpectedToWrite: Int, userData: AnyObject!) {
        
    }
    func tencentOAuth(tencentOAuth: TencentOAuth!, doCloseViewController viewController: UIViewController!) {
        
    }
}