//
//  KeyboardProcessProtocol.swift
//  travelMapMvvm
//
//  Created by green on 15/9/1.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation

/** 
 * 键盘处理(通常给viewcontroller实现)
 */
protocol KeyboardProcessProtocol {
    
    var scrollView : UIScrollView { get }
    var activeField : UITextField? { get set}
}