//
//  CoreTextData.swift
//  example02
//
//  Created by green on 15/8/5.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

// 用于保存由CTFrameParser类生成的CTFrameRef实例以及CTFrameRef实际绘制需要的高度
class CoreTextData: NSObject {
    
    var ctFrame     : CTFrameRef!   // 文字渲染区域的信息
    var height      : CGFloat!      // 实际绘制需要的高度
    var linkArray   : [CoreTextLinkData]?  // 超链数组
    var imageArray  : [CoreTextImageData]? // 图片frame、名称等信息
    {
        willSet {
            fillImagePosition(newValue!)
        }
    }
    
    init(ctFrame:CTFrameRef,height:CGFloat) {
        
        self.ctFrame    = ctFrame
        self.height     = height
    }
    
    /**
     * 设置图片在文字区域的坐标
     * @param imageArray 图片数组
     *
     * @return 
     */
    private func fillImagePosition(imageArray:[CoreTextImageData]) {
        
        if imageArray.count == 0 {
            return
        }
        let ctRunRectArray = CTFrameParserCAPI.findImagePosition(ctFrame) as! [NSValue]
        
        for (var i=0;i<imageArray.count;i++) {
            
            imageArray[i].imagePosition = ctRunRectArray[i].CGRectValue()
        }
    }

}
