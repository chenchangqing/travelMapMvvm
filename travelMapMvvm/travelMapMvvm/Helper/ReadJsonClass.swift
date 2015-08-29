//
//  ReadJsonClass.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//


class ReadJsonClass {
   
    /**
     * 解析json
     */
    class func readJsonData(fileName:String) -> (error:NSError?,data:AnyObject?){
        
        var error:NSError?
        var data:AnyObject?
        
        let path        = NSBundle.mainBundle().pathForResource(fileName, ofType: "json")
        
        if let path=path {
            
            let jsonData    = NSData(contentsOfFile: path)
            
            if let jsonData=jsonData {
                
                let tempResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: &error)
                
                if let tempResult=tempResult as? [String:AnyObject] {
                    
                    data = tempResult
                }
            }
        }
        
        return (error,data)
    }
}
