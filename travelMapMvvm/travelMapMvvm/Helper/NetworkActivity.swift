//
//  NetworkActivity.swift
//  travelMapMvvm
//
//  Created by green on 15/8/28.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation

var NetworkActivityCount = 0
let serialQueue = dispatch_queue_create("com.networkactivity.queue", DISPATCH_QUEUE_SERIAL);

public class NetworkActivity {
    
    public class func start() {
        dispatch_async(serialQueue) {
            NetworkActivityCount++
            NetworkActivity.updateNetworkStatus()
        }
    }
    
    public class func stop() {
        dispatch_async(serialQueue) {
            NetworkActivityCount--
            NetworkActivity.updateNetworkStatus()
        }
    }
    
    private class func updateNetworkStatus() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = (NetworkActivityCount > 0)
    }
}
