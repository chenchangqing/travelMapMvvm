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
        setupBindViewModel()
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
                    
                    self.hideHUD()
                }
            }
            
            if !errorMsg.isEmpty {
                
                self.showHUDErrorMessage(errorMsg)
            }
        }
    }
    
    /**
     * 绑定viewModel
     */
    private func setupBindViewModel() {
        
        // 激活 view model
        registerViewModel.active = true
        
        // 绑定tableView
        RACObserve(registerViewModel, "countryAndAreaCode").subscribeNextAs { (result:CountryAndAreaCode) -> () in
            
            self.tableView.reloadData()
        }
        
        // 绑定区号
        RACObserve(registerViewModel, "countryAndAreaCode.areaCode") ~> RAC(areaCodeL,"text")
        
        // 绑定按钮
        RACObserve(registerViewModel, "isValidTelephone") ~> RAC(btn,"enabled")
        RACObserve(registerViewModel, "isValidTelephone").mapAs { (isValid:NSNumber) -> UIColor in
            
            return isValid.boolValue ? UIButton.defaultBackgroundColor : UIButton.enabledBackgroundColor
        } ~> RAC(btn,"backgroundColor")
        
        // 绑定输入事件
        self.telField.rac_textSignal() ~> RAC(registerViewModel, "telephone")
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    @IBAction func unwindSegueToRegisterViewController(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        }
        
        cell!.detailTextLabel?.text = self.registerViewModel.countryAndAreaCode.countryName
        cell!.detailTextLabel?.textColor = UIColor.blackColor()
        cell!.textLabel?.text = "国家和地区"
        cell!.textLabel?.textColor = UIColor.darkGrayColor()
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        let countryVc = SectionsViewController()
//        countryVc.delegate = self
//        countryVc.setAreaArray(areaArray)
//        self.navigationController?.pushViewController(countryVc, animated: true)
    }
}
