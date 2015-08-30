//
//  CJCollectionViewHeaderModel.swift
//  SelectionCollectionView
//
//  Created by green on 15/8/21.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

enum CJCollectionViewHeaderModelTypeEnum : String {
    
    case MultipleChoice = "多选"
    case SingleChoice   = "单选"
    case SingleClick    = "单击"
    
    static let allValues = [MultipleChoice,SingleChoice,SingleClick]
    
    // 位置
    var index : Int {
        
        get {
            
            for var i = 0; i < CJCollectionViewHeaderModelTypeEnum.allValues.count; i++ {
                
                if self == CJCollectionViewHeaderModelTypeEnum.allValues[i] {
                    
                    return i
                }
            }
            return -1
        }
    }
    
    // 查询指定位置的元素
    static func instance(index:Int) -> CJCollectionViewHeaderModelTypeEnum? {
        
        if index >= 0 && index < CJCollectionViewHeaderModelTypeEnum.allValues.count {
            
            return CJCollectionViewHeaderModelTypeEnum.allValues[index]
        }
        return nil
    }
}

class CJCollectionViewHeaderModel: NSObject,NSCopying {
    
    var icon    : String? // 图片
    var title   : String? // 标题
    var type    : CJCollectionViewHeaderModelTypeEnum = .MultipleChoice // 该分类下按钮类型
    var isExpend : Bool = true  // 是否展开
    var isShowClearButton: Bool = false // 是否现实清除按钮
    var height : CGFloat = 50 // header高度
    
    // MARK: -
    
    init(icon: String?, title: String?) {
        
        self.icon = icon
        self.title = title
    }
    
    init(icon: String?, title: String?, type: CJCollectionViewHeaderModelTypeEnum) {
        
        self.icon = icon
        self.title = title
        self.type = type
    }
    
    init(icon: String?, title: String?, type: CJCollectionViewHeaderModelTypeEnum,isExpend:Bool) {
        
        self.icon = icon
        self.title = title
        self.type = type
        self.isExpend = isExpend
    }
    
    init(icon: String?, title: String?, type: CJCollectionViewHeaderModelTypeEnum,isExpend:Bool, isShowClearButton:Bool) {
        
        self.icon = icon
        self.title = title
        self.type = type
        self.isExpend = isExpend
        self.isShowClearButton = isShowClearButton
    }
    
    init(icon: String?, title: String?, type: CJCollectionViewHeaderModelTypeEnum,isExpend:Bool, isShowClearButton:Bool, height: CGFloat) {
        
        self.icon = icon
        self.title = title
        self.type = type
        self.isExpend = isExpend
        self.isShowClearButton = isShowClearButton
        self.height = height
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        
        return CJCollectionViewHeaderModel(icon: icon, title: title ,type: type, isExpend: isExpend, isShowClearButton: isShowClearButton, height :height)
    }
    
    required init(coder decoder: NSCoder) {
        
        self.icon         = decoder.decodeObjectForKey("icon") as? String
        self.title        = decoder.decodeObjectForKey("title") as? String
        self.type         = CJCollectionViewHeaderModelTypeEnum(rawValue:decoder.decodeObjectForKey("type") as! String)!
        self.isExpend        = decoder.decodeObjectForKey("isExpend") as! Bool
        self.isShowClearButton        = decoder.decodeObjectForKey("isShowClearButton") as! Bool
        self.height       = decoder.decodeObjectForKey("height") as! CGFloat
        
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        
        encoder.encodeObject(self.icon,forKey: "icon")
        encoder.encodeObject(self.title,forKey: "title")
        encoder.encodeObject(self.type.rawValue, forKey: "type")
        encoder.encodeObject(self.isExpend,forKey: "isExpend")
        encoder.encodeObject(self.isShowClearButton,forKey: "isShowClearButton")
        encoder.encodeObject(self.height,forKey: "height")
    }
    
    // MARK: - 重写比较方法
    
    override func isEqual(object: AnyObject?) -> Bool {
        
        if let object=object as? CJCollectionViewHeaderModel {
            
            if object.icon == self.icon && object.title == self.title {
                
                return true
            }
        }
        return false
    }
    
    override var hash: Int {
        
        get {
            
            let icon = self.icon == nil ? "" : self.icon!
            let title = self.title == nil ? "" : self.title!
            let iconTitle = icon + title
            
            return iconTitle.hash
        }
    }
    
    // MARK: - 重写描述
    
    override var description: String {
        
        get {
            
            return "{header.title:\(title)}"
        }
    }
    
}
