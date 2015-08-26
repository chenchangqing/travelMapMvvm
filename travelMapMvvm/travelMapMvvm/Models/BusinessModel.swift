//
//  JSONModel.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation

class BusinessModel :NSObject {
    
    var success : Bool = false
    var msg: String?
    var data: AnyObject?
    
    override init() {}
    
    init(success:Bool, msg:String?, data:AnyObject?) {
        
        self.success = success
        self.msg = msg
        self.data = data
    }
    
    override var description : String {
        
        get {
            
            return "{'success':\(success),'msg':\(msg),'data':\(data)}"
        }
    }
}