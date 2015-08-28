//
//  ResultModel.swift
//  travelMapMvvm
//
//  Created by green on 15/8/28.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit

class ResultModel: NSObject {
   
    var success:Bool = false
    var msg: String?
    var data: AnyObject?
    
    init(success:Bool,msg:String?,data:AnyObject?) {
        
        self.success = success
        self.msg = msg
        self.data = data
    
    }
}
