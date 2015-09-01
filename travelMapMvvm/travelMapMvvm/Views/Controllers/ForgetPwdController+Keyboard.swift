//
//  ForgetPwdController+Keyboard.swift
//  travelMapMvvm
//
//  Created by green on 15/9/1.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation

extension ForgetPwdController:UIScrollViewDelegate {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 实现键盘显示通知的selector中的方法
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillBeHidden:"), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    
    // MARK: - 键盘处理
    
    func keyboardWasShown(aNotification: NSNotification) {
        
        let userinfo = aNotification.userInfo!
        
        let value = userinfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let kbSize = value.CGRectValue().size
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        scrollV.contentInset = contentInsets
        scrollV.scrollIndicatorInsets = contentInsets
        
        let aRect = CGRectMake(0, 64, CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds) - 64 - kbSize.height)
        
        let aPoint = CGPointMake(32, activeF!.superview!.frame.origin.y + activeF!.frame.origin.y + 72)
        
        if !CGRectContainsPoint(aRect, aPoint) {
            
            let scrollPoint = CGPointMake(0.0, aPoint.y - kbSize.height)
            scrollV.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    func keyboardWillBeHidden(aNotification: NSNotification) {
        
        let contentInsets = UIEdgeInsetsZero
        scrollV.contentInset = contentInsets
        scrollV.scrollIndicatorInsets = contentInsets
    }
    
    // MARK: - UITextFieldDelegate
    
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    // 指定输入框对象
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        activeF = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        activeF = nil
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 0 {
            
            view.endEditing(true)
        }
    }
}