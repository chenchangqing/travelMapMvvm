//
//  CJCollectionViewCell.swift
//  SelectionCollectionView
//
//  Created by green on 15/8/21.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

/**
 * collectionView cell
 */
class CJCollectionViewCell: UICollectionViewCell {
    
    /**
     * icon
     */
    var icon : UIImage?
    {
        willSet {
            
            if let newValue = newValue {
                
                button.setImage(newValue, forState: UIControlState.Normal)
                button.setImage(newValue, forState: UIControlState.Selected)
            } else {
                
                button.setImage(nil, forState: UIControlState.Normal)
                button.setImage(nil, forState: UIControlState.Selected)
            }
        }
        
        didSet {
            
            changePaddingBetweenIconAndTitle()
        }
    }
    
    /**
     * title
     */
    var title: String?
    {
        willSet {
            
            button.setTitle(newValue, forState: UIControlState.Normal)
            button.setTitle(newValue, forState: UIControlState.Selected)
        }
    }
    
    /**
     * indexPath 按钮位置
     */
    var indexPath: NSIndexPath! {
        
        willSet {
            
            button.indexPath = newValue
        }
    }
    
    /**
     * 重写是否选中
     */
    override var selected : Bool {
        
        willSet {
            
            button.selected = newValue
        }
    }
    
    /**
     * delegate
     */
    var delegate : CJCollectionViewCellDelegate?
    
    // MARK: - Private
    
    private var button: CJCollectionViewCellButton!
    
    // MARK: - Constants
    
    /**
     * icon 与 title 之间的距离
     */
    private let marginBetweenIconAndTitle :CGFloat = 5
    
    // MARK: -
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        changePaddingBetweenIconAndTitle()
    }
    
    // MARK: - setup
    
    private func setup() {
        
        setupButton()
        
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = UIColor.redColor()
//        self.selectedBackgroundView = backgroundView
    }
    
    private func setupButton() {
        
        // create
        button = CJCollectionViewCellButton()
        button.generalStyle()
        button.selectionStyle()
        button.userInteractionEnabled = true
        
        // add
        contentView.addSubview(button)
        
        // constrains
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[button]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["button":button]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[button]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["button":button]))
        
        // event
        button.addTarget(self, action: Selector("buttonClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    // MARK: -
    
    /**
     * 改变 icon 与 title 之间的距离
     */
    private func changePaddingBetweenIconAndTitle() {
        
        if let icon = icon {
            
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, marginBetweenIconAndTitle)
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        } else {
            
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    // MARK: - EVENT
    
    func buttonClicked(sender:CJCollectionViewCellButton) {
        
        if let delegate = delegate {
            delegate.collectionViewCellClicked(sender)
        }
    }
}
