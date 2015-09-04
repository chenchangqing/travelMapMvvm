//
//  String+General.swift
//  travelMapMvvm
//
//  Created by green on 15/9/4.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation

extension String {
    
    var length : Int {
        
        get {
        
            return count(self.trim())
        }
    }
    
    func trim() -> String {
        
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}