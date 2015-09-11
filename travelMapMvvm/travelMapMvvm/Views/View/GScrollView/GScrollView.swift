//
//  GScrollView.swift
//  travelMap
//
//  Created by green on 15/7/8.
//  Copyright (c) 2015年 com.city8. All rights reserved.
//

import UIKit

class IndexUITapGestureRecognizer:UITapGestureRecognizer{
    
    var index:Int = 0
}

@IBDesignable class GScrollView: UIScrollView {
    
    var dataSource = [POIModel]()
        {
        willSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var verticalBuffer:CGFloat = 4
    @IBInspectable var horizontalBuffer:CGFloat = 4
    @IBInspectable var ratio:CGFloat = 0.5
    @IBInspectable var selectIndex:Int? {
        
        willSet {
            
            for (var i=0;i<self.subviews.count;i++){
                
                if i == newValue {
                    
                    (self.subviews[i] as! UIView).layer.borderColor = self.selectColor.CGColor
                    (self.subviews[i] as! UIView).layer.borderWidth = 1
                    
                    selectFunc(index: i)
                } else {
                    
                    (self.subviews[i] as! UIView).layer.borderWidth = 0
                    
                    unselectFunc(index: i)
                }
            }
        }
    }
    @IBInspectable var selectColor = UIColor.redColor()
    
    var selectFunc:(index:Int) -> () = {index in }
    var unselectFunc:(index:Int) -> () = {index in }
    
    private var width:CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func drawRect(rect: CGRect) {
        
        reset()
        if dataSource.count > 0 {
            
            self.selectIndex = 0
        }
    }
    
    private func reset() {
        
        for subV in self.subviews {
            
            subV.removeFromSuperview()
        }
        
        var x: CGFloat = horizontalBuffer
        for (var i=0;i<dataSource.count;i++) {
            
            let height: CGFloat = self.frame.size.height - (2 * verticalBuffer)
            width = height / ratio
            let y: CGFloat = verticalBuffer
            
            //            let subV = UIView(frame: CGRectMake(x, y, width, height))
            
            let subV = NSBundle.mainBundle().loadNibNamed("ScrollSubView", owner: nil, options: nil).first! as! ScrollSubView
            subV.nameL.text = dataSource[i].poiName
            subV.indexL.text = "\(i+1)"
            subV.frame = CGRectMake(x, y, width, height)
            self.addSubview(subV)
            
            if i == selectIndex {
                
                subV.layer.borderColor = selectColor.CGColor
                subV.layer.borderWidth = 1
            }
            subV.backgroundColor = UIColor.whiteColor()
            
            self.addSubview(subV)
            
            x += width + horizontalBuffer
            
            // 增加收拾
            let singleRecognizer = IndexUITapGestureRecognizer(target: self, action: Selector("singleTap:"))
            singleRecognizer.numberOfTapsRequired = 1
            singleRecognizer.index = i
            subV.addGestureRecognizer(singleRecognizer)
        }
        self.contentSize = CGSizeMake(x, self.frame.size.height)
    }
    
    func singleTap(recognizer:IndexUITapGestureRecognizer){
        
        if selectIndex == recognizer.index {
            
            self.selectIndex = nil
        } else {
            
            self.selectIndex = recognizer.index
        }
    }
    
    // MARK: - 对外方法
    
    func focus(index: Int?) {
        
        if index != nil {
            
            // 位置使选中成为第一个
            let v = self.subviews[index!] as! UIView
            let midx = CGRectGetMidX(v.frame)
            let x = midx - width/2 - horizontalBuffer
            self.scrollRectToVisible(CGRectMake(x, 1, UIScreen.mainScreen().bounds.size.width, 1), animated: true)
        }
        
        self.selectIndex = index
    }
}
