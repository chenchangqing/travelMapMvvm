//
//  VerifyViewController.swift
//  travelMap
//
//  Created by green on 15/6/18.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var verifyCodeF: UITextField!
    @IBOutlet weak var passwordF: UITextField!
    @IBOutlet weak var timeB: UIButton!
    @IBOutlet weak var timeL: UILabel!
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        setAllUIStyle()
    }
    
    // MARK: -
    
    /**
    * 设置UIStyle
    */
    private func setAllUIStyle() {
        
        view1.loginRadiusStyle()
        view2.loginRadiusStyle()
        view3.loginRadiusStyle()
        submitBtn.loginNoBorderStyle()
    }
}
