//
//  RegisterViewController.swift
//  travelMap
//
//  Created by green on 15/6/17.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit
import ReactiveCocoa

class RegisterViewController: UIViewController {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var areaCodeL: UILabel!
    @IBOutlet weak var telField: UITextField!
    
    var registerViewModel = RegisterViewModel()     // view model
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    // MARK: -
    
    private func setup() {
        
        setupAllUIStyle()
        setupMessages()
        
        // 激活 view model
        registerViewModel.active = true
    }
    
    /**
     * 设置UIStyle
     */
    private func setupAllUIStyle() {
        
        view1.loginRadiusStyle()
        view2.loginRadiusStyle()
        view3.loginRadiusStyle()
        btn.loginNoBorderStyle()
    }
    
    /**
     * 提示设置
     */
    private func setupMessages() {
        
        RACSignal.combineLatest([self.registerViewModel.searchZonesArrayCommand.executing
            ,RACObserve(registerViewModel, "errorMsg")]).subscribeNextAs { (tuple: RACTuple) -> () in
            
            let isLoading = tuple.first as! Bool
            let errorMsg  = tuple.second as! String
            
            if isLoading {
                
                self.showHUDIndicator()
            } else {
                
                if errorMsg.isEmpty {
                    
                    self.stopIndicatorAnimationAndStartFadeAnimation()
                    self.hideHUD()
                }
            }
            
            if !errorMsg.isEmpty {
                
                self.stopIndicatorAnimationAndStartFadeAnimation()
                self.showHUDErrorMessage(errorMsg)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    @IBAction func unwindSegueToRegisterViewController(segue: UIStoryboardSegue) {
        
    }
}
