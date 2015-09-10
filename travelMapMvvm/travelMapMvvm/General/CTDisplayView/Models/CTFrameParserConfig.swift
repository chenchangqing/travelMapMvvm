//
//  CTFrameParserConfig.swift
//  example02
//
//  Created by green on 15/8/5.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

// 用于配置绘制的参数，例如：文字颜色，大小，行间距等
class CTFrameParserConfig: NSObject {

    var width       : CGFloat = 200.0                   // 每行的宽度
    var fontSize    : CGFloat = 16.0                    // 文字的大小
    var lineSpace   : CGFloat = 8.0                     // 行间距
    var textColor   : UIColor = UIColor.blackColor()    // 文字颜色
}
