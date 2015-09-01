//
//  ForgetPwdController+Keyboard.swift
//  travelMapMvvm
//
//  Created by green on 15/9/1.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation

extension UIViewController:UIScrollViewDelegate {
    
    func registerKeyboardNotification() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillBeHidden:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func cancelKeyboardNotification() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override public func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        view.endEditing(true)
    }
    
    // MARK: - 键盘处理
    
    func keyboardWasShown(aNotification: NSNotification) {
        
        if let keyboardProcess=(self as? KeyboardProcessProtocol) {
            let userinfo = aNotification.userInfo!
            
            let value = userinfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            let kbSize = value.CGRectValue().size
            
            let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
            keyboardProcess.scrollView.contentInset = contentInsets
            keyboardProcess.scrollView.scrollIndicatorInsets = contentInsets
            
            let aRect = CGRectMake(0, 64, CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds) - 64 - kbSize.height)
            
            let aPoint = CGPointMake(32, keyboardProcess.activeField!.superview!.frame.origin.y + keyboardProcess.activeField!.frame.origin.y + 72)
            
            if !CGRectContainsPoint(aRect, aPoint) {
                
                let scrollPoint = CGPointMake(0.0, aPoint.y - kbSize.height)
                keyboardProcess.scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }

    func keyboardWillBeHidden(aNotification: NSNotification) {
        
        if let keyboardProcess=(self as? KeyboardProcessProtocol) {
            
            let contentInsets = UIEdgeInsetsZero
            keyboardProcess.scrollView.contentInset = contentInsets
            keyboardProcess.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    // 指定输入框对象
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        
        if let keyboardProcess=(self as? KeyboardProcessProtocol) {
            
            self.setValue(textField, forKey: "activeField")
        }
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        
        if let keyboardProcess=(self as? KeyboardProcessProtocol) {
            
            self.setValue(textField, forKey: "activeField")
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 0 {
            
            view.endEditing(true)
        }
    }
}