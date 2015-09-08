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
    
    
    // MARK: - Navigation
    
    @IBAction func unwindSegueToRegisterViewController(segue: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == kSegueFromRegisterViewControllerToVerifyViewController {
            
            let verifyViewController = segue.destinationViewController as! VerifyViewController
            
            verifyViewController.verifyViewModel = VerifyViewModel(registerViewModel: self.registerViewModel)
        }
    }
    
    // MARK: -
    
    private func setup() {
        
        setupAllUIStyle()
        setupMessages()
        setupBindViewModel()
        setupGetVerityCode()
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
        
        RACSignal.combineLatest([
            self.registerViewModel.searchZonesArrayCommand.executing,
            self.registerViewModel.sendVerityCodeCommand.executing,
            RACObserve(registerViewModel, "errorMsg")
        ]).subscribeNextAs { (tuple: RACTuple) -> () in
            
            let isLoading = tuple.first as! Bool || tuple.second as! Bool
            let errorMsg  = tuple.third as! String
            
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
        
        // 组合命令正在执行信号
        let commandExecutingSignal = RACSignal.combineLatest([
            self.registerViewModel.searchZonesArrayCommand.executing,
            self.registerViewModel.sendVerityCodeCommand.executing,
            RACObserve(registerViewModel, "isValidTelephone")
        ]).mapAs({ (tuple: RACTuple) -> NSNumber in
            
            let first   = tuple.first as! Bool
            let second  = tuple.second as! Bool
            let third   = tuple.third as! Bool
            
            let enabled = !first && !second && third
            
            return enabled
        })
        
        // 绑定按钮
        commandExecutingSignal ~> RAC(btn,"enabled")
        commandExecutingSignal.mapAs { (enabled:NSNumber) -> UIColor in
            
            return enabled.boolValue ? UIButton.defaultBackgroundColor : UIButton.enabledBackgroundColor
        } ~> RAC(btn,"backgroundColor")
        
        // 绑定输入事件
        self.telField.rac_textSignal() ~> RAC(registerViewModel, "telephone")
    }
    
    /**
     * 获取验证码
     */
    private func setupGetVerityCode() {
        
        // 获取验证码事件
        btn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (any:AnyObject!) -> Void in
            
            self.view.endEditing(true)
            
            let alertView = UIAlertView(
                title: "请确认手机号码",
                message:"我们将发送验证码到这个手机号码：\(self.areaCodeL.text!) \(self.telField.text!)",
                delegate: nil,
                cancelButtonTitle: "是",
                otherButtonTitles: "否")
            
            alertView.rac_buttonClickedSignal().subscribeNextAs({ (index:NSNumber) -> () in
                
                if index.integerValue == 0 {
                    
                    // 发送验证码
                    self.registerViewModel.sendVerityCodeCommand.execute(nil)
                }
            })
            
            alertView.show()
        }
        
        // 发送成功则跳转页面
        self.registerViewModel.sendVerityCodeCommand.executionSignals.subscribeNextAs { (signal:RACSignal) -> () in
            
            signal.dematerialize().deliverOn(RACScheduler.mainThreadScheduler()).skipUntilBlock({ (any:AnyObject!) -> Bool in
                
                return self == self.navigationController?.topViewController
            }).subscribeNext({ (any:AnyObject!) -> Void in
                
                // 跳转
                self.performSegueWithIdentifier(kSegueFromRegisterViewControllerToVerifyViewController, sender: nil)
            }, error: { (error:NSError!) -> Void in
                
                if let error = error as? SMS_SDKError {
                    
                    self.registerViewModel.errorMsg = "\(error.code),\(error.errorDescription)"
                } else {
                    
                    self.registerViewModel.errorMsg = error.localizedDescription
                }
            }, completed: { () -> Void in
                
            })
        }
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
        
        let countryVc = SectionsViewController()
        countryVc.delegate = registerViewModel
        countryVc.setAreaArray(registerViewModel.zonesArray)
        self.navigationController?.pushViewController(countryVc, animated: true)
    }
}
