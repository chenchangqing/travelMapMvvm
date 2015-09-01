//
//  ForgetPwdController.swift
//  travelMap
//
//  Created by green on 15/6/19.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit
import MBProgressHUD

class ForgetPwdController: UIViewController, KeyboardProcessProtocol {

    @IBOutlet weak var containerV: UIView!
    @IBOutlet weak var sureBtn: UIButton!
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    @IBOutlet weak var telF: UITextField!
    @IBOutlet weak var codeF: UITextField!
    @IBOutlet weak var pwdF: UITextField!
    @IBOutlet weak var pwdF2: UITextField!
    
    @IBOutlet weak var scrollV: UIScrollView!
    
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
        setAllUIStyle()
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
    
    /**
    * 设置UIStyle
    */
    private func setAllUIStyle() {
        
        containerV.loginRadiusStyle()
        sureBtn.loginNoBorderStyle()
    }
}
