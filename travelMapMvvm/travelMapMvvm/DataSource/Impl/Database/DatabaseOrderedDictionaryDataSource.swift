//
//  DatabaseOrderedDictionaryDataSource.swift
//  CJMvvm
//
//  Created by green on 15/8/25.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class DatabaseOrderedDictionaryDataSource: OrderedDictionaryDataSourceProtocol {
    
    /**
     * 单例
     */
    class func shareInstance() -> OrderedDictionaryDataSourceProtocol{
        
        struct CJSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:OrderedDictionaryDataSourceProtocol? = nil
        }
        
        dispatch_once(&CJSingleton.predicate,{
            
            CJSingleton.instance=DatabaseOrderedDictionaryDataSource()
        })
        return CJSingleton.instance!
    }
   
    func queryDictionary(fileName:String) -> OrderedDictionary<CJCollectionViewHeaderModel, [CJCollectionViewCellModel]> {
        
        // 单例
        struct DataSourceSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>!
        }
        
        dispatch_once(&DataSourceSingleton.predicate, { () -> Void in
            
            DataSourceSingleton.instance = OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>()
            
            let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "json")!
            let data     = NSFileManager.defaultManager().contentsAtPath(filePath)
            var error:NSError?
            if let data = data {
                
                let dataSource = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! [String:[[String:AnyObject]]]
                
                for key in dataSource.keys.array {
                    
                    let keyData = key.dataUsingEncoding(NSUTF8StringEncoding)!
                    let keyDic  = NSJSONSerialization.JSONObjectWithData(keyData, options: NSJSONReadingOptions.MutableContainers, error: nil) as! [String:AnyObject]
                    
                    let icon = keyDic["icon"] as? String
                    let title = keyDic["title"] as? String
                    let type = keyDic["type"] as? Int
                    let isExpend = keyDic["isExpend"] as? Bool
                    let isShowClearButton = keyDic["isShowClearButton"] as? Bool
                    let height = keyDic["height"] as? CGFloat
                    
                    let headerModel = CJCollectionViewHeaderModel(icon: icon, title: title)
                    if let type=type {
                        if let type=CJCollectionViewHeaderModelTypeEnum.instance(type) {
                            
                            headerModel.type = type
                        }
                    }
                    
                    if let isExpend=isExpend {
                        
                        headerModel.isExpend = isExpend
                    }
                    
                    if let isShowClearButton=isShowClearButton {
                        
                        headerModel.isShowClearButton = isShowClearButton
                    }
                    
                    if let height=height {
                        
                        headerModel.height = height
                    }
                    
                    
                    
                    var cellModels = [CJCollectionViewCellModel]()
                    let cellArray  = dataSource[key]!
                    
                    for cellDic in cellArray {
                        
                        let icon = cellDic["icon"] as? String
                        let title = cellDic["title"] as? String
                        let selected = cellDic["selected"] as? Bool
                        let width = cellDic["width"] as? CGFloat
                        
                        let cellModel = CJCollectionViewCellModel(icon: icon, title: title)
                        
                        if let selected=selected {
                            
                            cellModel.selected = selected
                        }
                        
                        if let width=width {
                            
                            cellModel.width = width
                        }
                        
                        cellModels.append(cellModel)
                    }
                    
                    DataSourceSingleton.instance[headerModel] = cellModels
                }
            }
        })
        
        return DataSourceSingleton.instance

    }
}
