//
//  RegisterViewController.swift
//  travelMap
//
//  Created by green on 15/6/17.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var areaCodeL: UILabel!
    @IBOutlet weak var telField: UITextField!
    
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
        btn.loginNoBorderStyle()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    @IBAction func unwindSegueToRegisterViewController(segue: UIStoryboardSegue) {
        
    }
}
