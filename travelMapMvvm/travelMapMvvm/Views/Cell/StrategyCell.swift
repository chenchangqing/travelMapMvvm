//
//  IndexViewCell.swift
//  travelMapMvvm
//
//  Created by green on 15/8/26.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import AFNetworking

/**
 * 攻略Cell 
 */
class StrategyCell: UITableViewCell {

    // 攻略图片
    @IBOutlet private weak var strategyPic: UIImageView!
    
    // 攻略名称
    @IBOutlet private weak var strategyNameL: UILabel!
    
    // 攻略创建日期
    @IBOutlet private weak var dateL: UILabel!
    
    // 攻略访问量
    @IBOutlet private weak var visiteNumL: UILabel!
    
    // 小编头像
    @IBOutlet private weak var authorHeadC: GCircleControl!
    
    // 小编名称
    @IBOutlet private weak var authorNameL: UILabel!
    
    private var strategyCellModel:StrategyCellModelProtocol = StrategyCellModel()
    
    // MARK: -
    
    // 攻略配图地址
    var picUrl: String? {
        
        willSet {
            
            if let newValue=newValue {
                
                if let url = NSURL(string: newValue) {
                    
                    strategyPic.setImageWithURL(url)
                }
            }
        }
    }
    
    // 攻略名称
    var title: String? {
        
        willSet {
            
            if let newValue=newValue {
                
                strategyNameL.text = newValue
            }
        }
    }
    
    // 创建时间 YYYY-MM-dd
    var createTime: String? {
        
        willSet {
            
            if let createTime=newValue {
                
                dateL.text = newValue
            }
        }
    }
    
    // 浏览次数
    var visitNumber: Int? {
        
        willSet {
            
            if let visitNumber=newValue {
                
                visiteNumL.text = "浏览量:\(visitNumber)次"
            }
        }
    }
    
    // 小编头像
    var authorPicUrl: String?{
        
        willSet {
            
            if let newValue=newValue {
                
                if let url=NSURL(string: newValue) {
                    
                    strategyCellModel.downloadStrategyImage(url)
                }
            }
        }
    }
    
    // 小编
    var author: String?{
        
        willSet {
            
            if let newValue=newValue {
                
                authorNameL.text = newValue
            }
        }
    }
    
    // MARK: -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
        
        // 设置kvo
        strategyCellModel.strategyCellObservedModel.addObserver(self, forKeyPath: pImage, options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    deinit {
        
        // 注销kvo
        strategyCellModel.strategyCellObservedModel.removeObserver(self, forKeyPath: pImage)
    }
    
    // MARK: - setup
    
    private func setup() {
        
        selectionStyle = UITableViewCellSelectionStyle.None
        strategyPic.layer.masksToBounds = true
        strategyPic.layer.cornerRadius = 8
    }
    
    // MARK: - 处理图片
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if keyPath == pImage {
            
            let newValue: AnyObject? = change[NSKeyValueChangeNewKey]
            
            if let newValue=newValue as? UIImage {
                
                // 更新图片
                authorHeadC.image = newValue
            }
        }
    }
}
