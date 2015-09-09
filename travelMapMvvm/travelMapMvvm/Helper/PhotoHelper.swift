//
//  PhotoHelper.swift
//  guanwawa
//
//  Created by green on 15/3/4.
//  Copyright (c) 2015年 city8. All rights reserved.
//

import UIKit
import AssetsLibrary
import AVFoundation
import AFNetworking

class PhotoHelper: NSObject {
    
    
    // MARK: 是否可以调用相册
    
    class func isCanVisitPhotos(vc:UIViewController) -> Bool {
        
        var flag        = false
        var author      = ALAssetsLibrary.authorizationStatus()
        
        // 已授权
        if author == ALAuthorizationStatus.Authorized {
            flag    = true
        }
        
        // 还没决定
        if author == ALAuthorizationStatus.NotDetermined {
            flag    = true
        }
        
        // 已拒绝
        if author == ALAuthorizationStatus.Denied {
            
            var alertVC = UIAlertController(title: "请授权访问相册", message: "设置方式:手机设置->隐私->照片", preferredStyle: UIAlertControllerStyle.Alert)
            var alert   = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (ation) -> Void in})
            alertVC.addAction(alert)
            vc.presentViewController(alertVC, animated: true, completion: {() -> Void in })
        }
        
        // 您的相册权限受限
        if author == ALAuthorizationStatus.Restricted {
            
            var alertVC = UIAlertController(title: "您的相册权限受限", message: "此应用程序没有被授权访问的照片数据。可能是家长控制权限。", preferredStyle: UIAlertControllerStyle.Alert)
            var alert   = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (ation) -> Void in})
            alertVC.addAction(alert)
            vc.presentViewController(alertVC, animated: true, completion: {() -> Void in })
        }
        
        return flag
    }
    
    // MARK: 是否可以调用相机
    
    class func isCanVisitCamera(vc:UIViewController) -> Bool {
        
        var flag        = false
        var author      = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        
        // 已授权
        if author == AVAuthorizationStatus.Authorized {
            flag    = true
        }
        
        // 还没决定
        if author == AVAuthorizationStatus.NotDetermined {
            flag    = true
        }
        
        // 已拒绝
        if author == AVAuthorizationStatus.Denied {
            
            var alertVC = UIAlertController(title: "请授权访问相机", message: "设置方式:手机设置->隐私->相机", preferredStyle: UIAlertControllerStyle.Alert)
            var alert   = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (ation) -> Void in})
            alertVC.addAction(alert)
            vc.presentViewController(alertVC, animated: true, completion: {() -> Void in })
        }
        
        // 您的相机权限受限
        if author == AVAuthorizationStatus.Restricted {
            
            var alertVC = UIAlertController(title: "您的相机权限受限", message: "此应用程序没有被授权访问的相机数据。可能是家长控制权限。", preferredStyle: UIAlertControllerStyle.Alert)
            var alert   = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (ation) -> Void in})
            alertVC.addAction(alert)
            vc.presentViewController(alertVC, animated: true, completion: {() -> Void in })
        }
        
        return flag
    }
    
    
    // MARK: 压缩图片
    
    class func compressImage(image:UIImage) -> UIImage {
        
        var smallImage:UIImage!
        
        var data            = UIImageJPEGRepresentation(image,1.0)
        var sizeOrigin      = data.length
        var sizeOriginKB    = sizeOrigin/1024
        println("压缩前:\(sizeOriginKB)")
        
        if sizeOriginKB > 200 {
            
            var a:CGFloat = 200
            var b:CGFloat = CGFloat(sizeOriginKB)
            var q:CGFloat = sqrt(a/b)
            
            var sizeImage           = image.size
            var widthSmall          = sizeImage.width * q
            var heighSmall          = sizeImage.height * q
            var sizeImageSmall      = CGSizeMake(widthSmall, heighSmall)
            
            UIGraphicsBeginImageContext(sizeImageSmall)
            var smallImageRect = CGRectMake(0, 0, sizeImageSmall.width, sizeImageSmall.height);
            image.drawInRect(smallImageRect)
            smallImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            
            var data1            = UIImageJPEGRepresentation(smallImage,1.0)
            var sizeOrigin1      = data1.length
            var sizeOriginKB1    = sizeOrigin1/1024
            println("压缩后:\(sizeOriginKB1)")
            
            compressImage(smallImage)
        } else {
            
            smallImage = image
            println("未压缩")
        }
        
//        var rate:CGFloat!
//        var size:CGSize!
//        if smallImage.size.width > image.size.height {
//            
//            rate = image.size.width/200
//        } else {
//            
//            rate = image.size.height/200
//        }
//        size = CGSizeMake(image.size.width/rate, image.size.height/rate)
//        UIGraphicsBeginImageContext(size)
//        smallImage.drawInRect(CGRectMake(0, 0, size.width, size.height))
//        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return smallImage
    }
}
