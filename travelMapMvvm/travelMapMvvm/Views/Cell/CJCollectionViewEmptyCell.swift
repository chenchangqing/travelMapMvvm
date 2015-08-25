//
//  CJCollectionViewEmptyCell.swift
//  SelectionCollectionView
//
//  Created by green on 15/8/22.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class CJCollectionViewEmptyCell: UICollectionViewCell {
    
    private var messageLabel : UILabel! // 提示
    
    // MARK: - Constant
    private let kMessageLabel = "messageLabel"
    
    // MARK: -
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    // MARK: - setup
    
    private func setup() {
        
        setupMessageLabel()
    }
    
    private func setupMessageLabel() {
        
        // create
        messageLabel = UILabel()
        messageLabel.text = "空"
        messageLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // add to self
        self.addSubview(messageLabel)
        
        // add constraints
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[\(kMessageLabel)]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: [kMessageLabel: messageLabel]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[\(kMessageLabel)]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: [kMessageLabel: messageLabel]))
    }
    
    
}
