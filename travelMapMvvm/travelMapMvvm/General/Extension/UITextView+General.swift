//
//  NSMutableAttributedString+General.swift
//  travelMapMvvm
//
//  Created by green on 15/9/10.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation

extension UITextView {
    
    func height(width:CGFloat) -> CGFloat {
        
        return self.sizeThatFits(CGSizeMake(width, CGFloat.max)).height
    }
}