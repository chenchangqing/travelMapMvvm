//
//  UIButton+Login.swift
//  travelMapMvvm
//
//  Created by green on 15/8/31.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation

extension UIButton {
    
    func loginBorderStyle() {
        
        self.layer.borderColor = ColorHelper.hexStringToUIColor("#E7E7E7").CGColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
    
    func loginNoBorderStyle() {
        
        self.backgroundColor = ColorHelper.hexStringToUIColor("#63B8FF")
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
    
    
}