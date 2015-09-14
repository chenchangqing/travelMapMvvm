//
//  CommentModel.swift
//  travelMap
//
//  Created by green on 15/6/30.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit

// POI评论
class CommentModel: NSObject, Deserializable {
   
    var commentId       : String?           // ID
    var author          : String?           // 评论人
    var authorPicUrl    : String?           // 头像
    var content         : String?           // 评论的内容
    var level           : POILevelEnum?     // 星级
    var commentTime     : String?           // YYYY-MM-dd HH:mm:ss
    
    override init() { }
    
    required init(data : [String:AnyObject]) {
        
        commentId      <-- data["commentId"]
        author         <-- data["author"]
        authorPicUrl   <-- data["authorPicUrl"]
        content        <-- data["content"]
        commentTime    <-- data["commentTime"]
        
        if let level=data["level"] as? String {
            
            self.level = POILevelEnum(rawValue: level)
        }
    }
}
