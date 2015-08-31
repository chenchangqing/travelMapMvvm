//
//  LeftViewController.swift
//  travelMapMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import ReactiveCocoa

/**
 * 侧边栏控制器
 */
class LeftViewController: UITableViewController {
    
    @IBOutlet private weak var headerView: UIView!      // header view
    @IBOutlet private weak var footerView: UIView!      // footer view
    
    @IBOutlet private weak var headC: GCircleControl!   // 头像circle控件
    @IBOutlet private weak var nameL: UILabel!          // 用户名称
    
    @IBOutlet private weak var loginStatusL: UILabel!   // 登录状态
    
    var userHeaderViewModel = ImageViewModel(urlString: nil,defaultImage:UIImage(named: "userHeader.jpg")!)
    
    // 当前用户
    var currentUser:UserModel?
    
    // 内容视图在 left view中上下等间距
    private lazy var contentViewMargin:CGFloat = {
        
        return CGRectGetHeight(UIScreen.mainScreen().bounds) * CGFloat(1 - self.sideMenuViewController!.contentViewScaleValue) / 2
    }()
    
    // MARK: - constant values
    
    private let kUserHeadCellHeight:CGFloat = 100           // 包含头像的cell高度
    private let kNumberOfCellWithoutHeadCell:CGFloat = 6    // tableView cell个数 - 一个head cell = 6
    private let kSeparatorMargin:CGFloat = 15               // 分割线的左右边距
    
    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        setupTopView()
        setupBottomView()
        setupTableViewSeparatorInset()
        setupCurrentUser()
        setupHeadC()
        
        // 设置用户名称 登入状态
        nameL.text = currentUser?.userName == nil ? "未登录" : currentUser?.userName
        loginStatusL.text = currentUser == nil ? "    登录账号" : "    退出账号"
    }
    
    // MARK: - setup
    
    /**
     * 调整topView的frame
     */
    private func setupTopView() {
        
        headerView.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), contentViewMargin)
    }
    
    /** 
     * 调整bottomView的frame
     */
    private func setupBottomView() {
        
        footerView.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), contentViewMargin)
    }
    
    /**
     * 调整tableView的分割线
     */
    private func setupTableViewSeparatorInset() {
        
        // 内容视图缩小后实际宽度
        let contentViewWidth:CGFloat = CGRectGetWidth(UIScreen.mainScreen().bounds) * CGFloat(self.sideMenuViewController!.contentViewScaleValue)
        
        // menu分割线的右边距（内容视图缩小后实际宽度的一半 - 内容视图中心偏移 + 分割线的右边距）
        let separatorRightMargin:CGFloat = contentViewWidth/2 - CGFloat(self.sideMenuViewController!.contentViewInPortraitOffsetCenterX) + self.kSeparatorMargin
        
        // 设置左右边距
        let insets = UIEdgeInsets(
            top: 0,
            left: self.kSeparatorMargin,
            bottom: 0,
            right:separatorRightMargin)
        
        tableView.separatorInset = insets
    }
    
    /**
     * 查询当前登录用户
     */
    private func setupCurrentUser() {
        
        var uData = NSUserDefaults.standardUserDefaults().objectForKey(kUser) as? NSData
        
        if let ud=uData {
            currentUser = NSKeyedUnarchiver.unarchiveObjectWithData(ud) as? UserModel
        }
    }
    
    /**
     * 初始化头像circle控件
     */
    private func setupHeadC() {
        
        headC.enabled = false
        if let image = userHeaderViewModel.loadImageWithCache() {
            
            headC.image = image
        } else {
            
            RACObserve(userHeaderViewModel, "image") ~> RAC(headC, "image")
        }
    }
    
    // MARK: - UITableView
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        // UserHeader Cell
        if indexPath.row == 0 {
            return kUserHeadCellHeight
        }
        
        return (CGRectGetHeight(UIScreen.mainScreen().bounds) * CGFloat(sideMenuViewController!.contentViewScaleValue) - kUserHeadCellHeight) / kNumberOfCellWithoutHeadCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        switch (indexPath.row) {
            
        // 点击头像所在行
        case 0:
            
            if let currentUser=currentUser {
                
                println("已经登录")
            } else {
                
                // 跳转至登录页面
                let loginViewControllerNav = self.getViewController("Login", identifier: "LoginViewControllerNav")
                if let loginViewControllerNav=loginViewControllerNav {
                    
                    sideMenuViewController?.contentViewController?.presentViewController(loginViewControllerNav, animated: true, completion: nil)
                    sideMenuViewController?.hideMenuViewController()
                }
            }
            
            break;
            
        // 点击首页所在行
        case 1:
            
            sideMenuViewController?.contentViewController = getViewController("main", identifier: "IndexViewControllerNav")
            sideMenuViewController?.hideMenuViewController()
            
            break;
            
        // 点击我的旅行地所在行
        case 2:
            
            break;
            
        // 点击我的地图所在行
        case 3:
            
            break;
            
        // 点击修改资料所在行
        case 4:
            
            break;
            
        // 点击工具箱
        case 5:
            
            break;
            
        // 点击登录帐号/登出帐号所在行
        case 6:
            
            if let currentUser=currentUser {
                
                println("已经登录")
            } else {
                
                println("没有登录")
            }
            
            break;

        default:
            break;
        }
    }

}
