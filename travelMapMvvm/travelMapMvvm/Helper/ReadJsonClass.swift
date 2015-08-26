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
    class func readJsonData(fileName:String) -> [String:AnyObject] {
        
        var result = [String:AnyObject]()
        
        let path        = NSBundle.mainBundle().pathForResource(fileName, ofType: "json")
        
        if let path=path {
            
            let jsonData    = NSData(contentsOfFile: path)
            
            if let jsonData=jsonData {
                
                let tempResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
                
                if let tempResult=tempResult as? [String:AnyObject] {
                    
                    result = tempResult
                }
            }
        }
        
        return result
    }
}
