//
//  CoreTextUtils.swift
//  example02
//
//  Created by green on 15/8/9.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class CoreTextUtils: NSObject {
    
    /**
    * 找超链
    * @param view 视图
    * @param point 触摸点
    * @param data 富文本数据
    *
    * @return 超链
    */
    class func touchLink(#view:UIView,atPoint point:CGPoint,data:CoreTextData) -> CoreTextLinkData? {
        
        let idx = CTFrameParserCAPI.touchContentOffsetInView(view, atPoint: point, data: data.ctFrame)
        if idx == -1 {
            return nil
        }
        if let linkArray = data.linkArray {
            
            let foundLink = self.link(atIndex: idx, linkArray: linkArray)
            return foundLink
        }
        return nil
    }
    
    /**
     * 查找超链
     * @param index 点击的位置在富文本中的位置
     * @param linkArray 超链数组
     *
     * @return 超链
     */
    class func link(atIndex index:CFIndex ,linkArray:[CoreTextLinkData]) -> CoreTextLinkData? {
        
        for coreTextLinkData in linkArray {
            
            if NSLocationInRange(index, coreTextLinkData.range) {
                
                return coreTextLinkData
            }
        }
        return nil
    }
}
