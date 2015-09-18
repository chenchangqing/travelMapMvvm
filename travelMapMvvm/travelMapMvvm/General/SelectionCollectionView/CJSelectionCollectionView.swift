//
//  CJSelectionCollectionView.swift
//  SelectionCollectionView
//
//  Created by green on 15/8/21.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class CJSelectionCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate,CJCollectionViewHeaderDelegate,CJCollectionViewCellDelegate {
    
    /**
    * 数据源
    */
    var dataSource = OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>() {
        
        didSet {
            
            caculate()
            
            // 保存原始数据
            originalDataSource = OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>()
            for (headerModel,cellModels) in dataSource {
                
                let headerModelCopy = headerModel.copy() as! CJCollectionViewHeaderModel
                var cellModelsCopy = [CJCollectionViewCellModel]()
                
                for cellModel in cellModels {
                    
                    cellModelsCopy.append(cellModel.copy() as! CJCollectionViewCellModel)
                }
                
                originalDataSource[headerModelCopy] = cellModelsCopy
            }
            
            // 判断是否有选中的cell
            let querySelectedCellModel:(cellModels:[CJCollectionViewCellModel]) -> CJCollectionViewCellModel? = {
                cellModels in
                
                for cellModel in cellModels {
                    
                    if cellModel.selected {
                        
                        return cellModel
                    }
                }
                
                return nil
            }
            
            // 根据分类类型是 多选 单选 单击，增加或删除 全部 选项
            
            for (headerModel,var cellModels) in dataSource {
                
                switch (headerModel.type) {
                case .MultipleChoice:
                    
                    let allChoiceModel = CJCollectionViewCellModel(icon: nil, title: kAllTitle)
                    
                    if let cellModel=querySelectedCellModel(cellModels: cellModels) {
                        
                        allChoiceModel.selected = false
                    } else {
                        
                        allChoiceModel.selected = true
                    }
                    
                    let array = NSMutableArray(array: cellModels)
                    if !array.containsObject(allChoiceModel) && array.count != 0 {
                        
                        cellModels.insert(allChoiceModel.copy() as! CJCollectionViewCellModel, atIndex: 0)
                        dataSource[headerModel] = cellModels
                    }
                    
                    break;
                case .SingleChoice:
                    
                    let allChoiceModel = CJCollectionViewCellModel(icon: nil, title: kAllTitle)
                    
                    if let cellModel=querySelectedCellModel(cellModels: cellModels) {
                    
                        for temp in cellModels {
                            
                            if temp != cellModel {
                                
                                temp.selected = false
                            }
                        }
                    }
                    
                    let array = NSMutableArray(array: cellModels)
                    if array.containsObject(allChoiceModel) {
                        
                        let allChoiceModelIndex = array.indexOfObject(allChoiceModel)
                        cellModels.removeAtIndex(allChoiceModelIndex)
                        dataSource[headerModel] = cellModels
                    }
                    
                    break;
                case .SingleClick:
                    
                    let allChoiceModel = CJCollectionViewCellModel(icon: nil, title: kAllTitle)
                    
                    for temp in cellModels {
                        
                        temp.selected = false
                    }
                    
                    let array = NSMutableArray(array: cellModels)
                    if array.containsObject(allChoiceModel) {
                        
                        let allChoiceModelIndex = array.indexOfObject(allChoiceModel)
                        cellModels.removeAtIndex(allChoiceModelIndex)
                        dataSource[headerModel] = cellModels
                    }
                    
                    break;
                    
                default:
                    break;
                }
            }
        }
    }
    
    /**
    * collection View 左边距
    */
    var collectionViewLeftMargin : CGFloat = 16
    
    /**
    * collection View 右边距
    */
    var collectionViewRightMargin : CGFloat = 16
    
    /**
    * collection View 上边距
    */
    var collectionViewTopMargin : CGFloat = 8
    
    /**
    * collection View 下边距
    */
    var collectionViewBottomMargin : CGFloat = 8
    
    /**
    * cell 之间的水平间距
    */
    var cellHorizontalMargin : CGFloat = 12
    
    /**
    * cell 可以改变cell中内容到左右边界的距离
    */
    var cellHorizontalPadding : CGFloat = 20
    
    /**
    * 默认显示行数
    */
    var defaultRows:Int = 1
    
    /**
    * 点击单元格事件
    */
    var cellClicked : (headerModel:CJCollectionViewHeaderModel,cellModel:CJCollectionViewCellModel) -> Void = { (header,celModel) in }
    
    /**
    * 选中数组
    */
    var resultDictionary : OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]> {
        
        get {
            
            var resultArray = OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>()
            
            let allChoiceModel = CJCollectionViewCellModel(icon: nil, title: kAllTitle)
            
            for (headerModel,cellModels) in dataSource {
                
                if headerModel.type != .SingleClick {
                    
                    var tempCellModels = [CJCollectionViewCellModel]()
                    
                    for tempCellModel in cellModels {
                        
                        if tempCellModel.isEqual(allChoiceModel) {
                            
                            if tempCellModel.selected {
                                
                                let array = NSMutableArray(array: cellModels)
                                let index = array.indexOfObject(allChoiceModel)
                                tempCellModels = cellModels
                                tempCellModels.removeAtIndex(index)
                                
                                break
                            }
                        } else {
                            
                            
                            if tempCellModel.selected {
                                
                                tempCellModels.append(tempCellModel)
                            }
                        }
                    }
                    
                    resultArray[headerModel] = tempCellModels
                }
            }
            
            return resultArray
        }
    }
    
    // MARK: - Private
    
    private var collectionView : UICollectionView!
    
    // 每个分类下有几行，每行有几个cell
    private var cellCountDictionary :[CJCollectionViewHeaderModel:[Int]]!
    
    // 每个分类下默认显示行包含的cell数量
    private var defaultCellCountForSectionDictionary :[CJCollectionViewHeaderModel:Int]!
    
    // 每个分类下是否应该显示更多按钮字典
    private var isShowMoreBtnDictionary :[CJCollectionViewHeaderModel:Bool]!
    
    // cell所能占据的最大宽度
    private var limitWidth: CGFloat! {
        
        get {
            
            return CGRectGetWidth(collectionView.bounds) - collectionViewLeftMargin - collectionViewRightMargin
        }
    }
    
    // 原始数据
    private var originalDataSource = OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>()
    
    
    // MARK: - Constants
    
    private let kCellIdentifier             = "CellIdentifier"                // 重用单元格ID
    private let kCellIdentifierEmpty        = "CellIdentifierEmpty"           // 空单元格ID
    private let kHeaderViewCellIdentifier   = "HeaderViewCellIdentifier"      // 重用标题ID
    private let kCollectionView             = "collectionView"                // 增加约束时使用
    private let kCollectionViewCellHeight   : CGFloat          = 30           // cell height
    private let kAllTitle                   = "全部"
    
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
        
        // 计算
        caculate()
    }
    
    // MARK: - 公开方法
    
    /**
    * 重置
    */
    func reset() {
        
        dataSource = originalDataSource
        collectionView.reloadData()
    }
    
    /**
    * 刷新
    */
    func reloadData() {
        
        collectionView.reloadData()
    }
    
    // MARK: - setup
    
    private func setup() {
        
        // 初始化 collectionView
        setupCollectionView()
    }
    
    /**
    * 初始化 collectionView
    */
    private func setupCollectionView() {
        
        // create
        let layout      = UICollectionViewLeftAlignedLayout()
        collectionView  = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        
        // 默认为黑色，这里设置为白色以便显示
        collectionView.backgroundColor = UIColor.whiteColor()
        
        // 默认collectionView多选
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        
        // add collectionView
        self.addSubview(collectionView)
        
        // 重用Cell、Header
        collectionView.registerClass(CJCollectionViewCell.self, forCellWithReuseIdentifier: kCellIdentifier)
        collectionView.registerClass(CJCollectionViewEmptyCell.self, forCellWithReuseIdentifier: kCellIdentifierEmpty)
        collectionView.registerClass(CJCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewCellIdentifier)
        
        // 设置collection代理为self
        collectionView.dataSource   = self
        collectionView.delegate     = self
        
        // add constrains
        collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[\(kCollectionView)]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: [kCollectionView: collectionView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[\(kCollectionView)]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: [kCollectionView: collectionView]))
        
    }
    
    // MARK: -  处理数据
    
    /**
    * 返回指定节的key
    */
    private func keyForSection(section:Int) -> CJCollectionViewHeaderModel {
        
        return dataSource.keys[section]
    }
    
    /**
    * 返回指定节的数据数组
    */
    private func arrayForSection(section:Int) -> [CJCollectionViewCellModel] {
        
        return dataSource[keyForSection(section)]!
    }
    
    /**
    * 返回指定cell的数据字典
    */
    private func dictionaryForRow(indexPath:NSIndexPath) -> CJCollectionViewCellModel {
        
        return arrayForSection(indexPath.section)[indexPath.row]
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        println("didSelectItemAtIndexPath:\(indexPath)")
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        println("didDeselectItemAtIndexPath:\(indexPath)")
    }
    
    // MARK: - CJCollectionViewCellDelegate
    
    func collectionViewCellClicked(sender: CJCollectionViewCellButton) {
        
        let cellModel = dictionaryForRow(sender.indexPath)
        
        let headerModel = keyForSection(sender.indexPath.section)
        
        let cellModels = arrayForSection(sender.indexPath.section)
        
        let allChoiceModel = CJCollectionViewCellModel(icon: nil, title: kAllTitle)
        
        switch (headerModel.type) {
        case .MultipleChoice:
            
            // 更新当前按钮model
            cellModel.selected = !cellModel.selected
            
            // 当前点击的按钮为全部
            if cellModel.title == kAllTitle {
                
                // 更新非全部按钮model
                if cellModel.selected {
                    
                    for tempCellModel in cellModels{
                        
                        if !cellModel.isEqual(tempCellModel) {
                            
                            tempCellModel.selected = false
                        }
                    }
                    
                }
            }
            
            // 当前点击的按钮非全部
            if cellModel.title != kAllTitle {
                
                // 更新非全部按钮model
                if cellModel.selected {
                    
                    // 是否全部选中
                    var flag = true
                    
                    // 判断是否全部选中
                    for tempCellModel in cellModels {
                        
                        if !tempCellModel.isEqual(allChoiceModel) && !tempCellModel.selected {
                            
                            flag = false
                            break
                        }
                    }
                    
                    // 全部选中
                    if flag {
                        
                        for tempCellModel in cellModels {
                            
                            if tempCellModel.isEqual(allChoiceModel) {
                                
                                tempCellModel.selected = true
                                break
                            }
                        }
                        
                        for tempCellModel in cellModels {
                            
                            if !tempCellModel.isEqual(allChoiceModel) {
                                
                                tempCellModel.selected = false
                            }
                        }
                    }
                    
                    // 没有全部选中
                    if !flag {
                        
                        for tempCellModel in cellModels{
                            
                            if allChoiceModel.isEqual(tempCellModel) {
                                
                                tempCellModel.selected = false
                            }
                        }
                    }
                    
                }
            }
            
            // 更新当前分类
            self.collectionView.reloadSections(NSIndexSet(index: sender.indexPath.section))
            
            break;
        case .SingleChoice:
            
            cellModel.selected = !cellModel.selected
            
            if cellModel.selected {
                
                for tempCellModel in cellModels {
                    
                    if !tempCellModel.isEqual(cellModel) {
                        
                        tempCellModel.selected = false
                    }
                }
            }
            
            // 更新当前分类
            self.collectionView.reloadSections(NSIndexSet(index: sender.indexPath.section))
            
            break;
        case .SingleClick:
            
            self.cellClicked(headerModel:headerModel, cellModel: cellModel)
            
            break;
            
        default:
            break;
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    /**
    * cells count
    */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // 指定分类下没有数据时，设置一个空，此时返回1
        if arrayForSection(section).count == 0 {
            
            return 1
        }
        
        // 指定分类下有数据时，如果更多按钮状态为选中则显示所有cell，反之只显示默认行数下的cell
        let key = keyForSection(section)
        
        if key.isExpend {
            
            return arrayForSection(section).count
        }
        
        return defaultCellCountForSectionDictionary[key]!
    }
    
    /**
    * cell
    */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 指定分类下没有数据时，现实空cell
        if arrayForSection(indexPath.section).count == 0 {
            
            let emptyCell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifierEmpty, forIndexPath: indexPath) as! CJCollectionViewEmptyCell
            return emptyCell
        }
        
        // 指定分类下有数据时，现实正常的cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath) as! CJCollectionViewCell
        
        // 处理数据
        let item            = dictionaryForRow(indexPath)
        let cellTitle       = item.title
        let cellIcon        = item.icon
        
        // 文字
        cell.title = cellTitle
        if let cellIcon = cellIcon {
            
            cell.icon = UIImage(named: cellIcon)
        } else {
            
            cell.icon = nil
        }
        
        // 设置cell的位置
        cell.indexPath = indexPath
        
        // delegate
        cell.delegate = self
        
        // 设置按钮是否被选中
        cell.selected = item.selected
        
        return cell
    }
    
    /**
    * sections count
    */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return dataSource.count
    }
    
    /**
    * header
    */
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewCellIdentifier, forIndexPath: indexPath) as! CJCollectionViewHeader
        
        // 处理数据
        header.titleButtonTitle = keyForSection(indexPath.section).title
        
        if let icon=keyForSection(indexPath.section).icon {
            
            header.titleButtonIcon  = UIImage(named: icon)
        }
        
        // 记录位置
        header.section = indexPath.section
        
        // 是否显示更多
        let key = keyForSection(indexPath.section)
        
        header.moreButtonHidden = !isShowMoreBtnDictionary[key]!
        
        // 设置更多按钮的状态
        if key.isExpend {
            
            header.moreButtonSelected = true
        } else {
            
            header.moreButtonSelected = false
        }
        
        // delegate
        header.delegate = self
        
        // header 左右边距
        header.leftMargin = collectionViewLeftMargin
        header.rightMargin = collectionViewRightMargin
        
        // 是否显示清空按钮
        header.isShowClearButton  = key.isShowClearButton
        
        return header
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    /**
    * cell size
    */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        // 指定分类下没有数据时，设置cell width
        if arrayForSection(indexPath.section).count == 0 {
            
            return CGSizeMake(limitWidth, kCollectionViewCellHeight)
        }
        
        // 指定分类下有数据时，需要计算cell width
        let cellModel = dictionaryForRow(indexPath)
        let cellWidth = caculateCellWidth(cellModel)
        
        return CGSizeMake(cellWidth, kCollectionViewCellHeight)
    }
    
    /**
    * collectionview edge
    */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(collectionViewTopMargin, collectionViewLeftMargin, collectionViewBottomMargin, collectionViewRightMargin)
    }
    
    /**
    * cell 左右之间的最小间距
    */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return cellHorizontalMargin
    }
    
    /**
    * header size
    */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let key = keyForSection(section)
        return CGSizeMake(CGRectGetWidth(self.bounds) - 50, key.height)
    }
    
    // MARK: - CJCollectionViewHeaderDelegate
    
    func collectionViewHeaderMoreBtnClicked(sender: UIButton) {
        
        sender.selected = !sender.selected
        
        let key = keyForSection(sender.tag)
        key.isExpend = sender.selected
        
        // 更新collectionView
        reloadSection(sender.tag)
    }
    
    func collectionViewHeaderClearBtnClicked(sender: UIButton) {
        
        let key = keyForSection(sender.tag)
        
        dataSource[key] = [CJCollectionViewCellModel]()
        
        // 计算
        caculate()
        
        // 更新collectionView
        reloadSection(sender.tag)
    }
    
    /**
    * 更新指定分类数据
    *
    * @param section 分类位置
    */
    private func reloadSection(section:Int) {
        
        collectionView.performBatchUpdates({ () -> Void in
            
            let section = NSIndexSet(index: section)
            self.collectionView.reloadSections(section)
            }, completion: { (finished) -> Void in
                
        })
        
    }
    
    // MARK: - caculate
    
    /**
    * 计算cell的width
    *
    * @param cell单元格数据
    *
    * @return cell的宽度
    */
    private func caculateCellWidth(cellModel:CJCollectionViewCellModel) -> CGFloat {
        
        var cellWidth:CGFloat = 0
        
        if let title = cellModel.title {
            
            if cellModel.width != 0 {
                
                cellWidth = cellModel.width >= limitWidth ? limitWidth : cellModel.width
            } else {
                
                let size  = title.sizeWithAttributes([NSFontAttributeName:UIFont.systemFontOfSize(16)])
                cellWidth = CGFloat(ceilf(Float(size.width))) + cellHorizontalPadding
                
                if let icon=cellModel.icon {
                    
                    // 如果包含图片，增加item的宽度
                    cellWidth += cellHorizontalPadding
                }
                
                // 如果通过文字+图片计算出来的宽度大于等于限制宽度，则改变单元格item的实际宽度
                cellWidth = cellWidth >= limitWidth ? limitWidth : cellWidth
            }
        }
        
        return cellWidth
    }
    
    /**
    * 计算cell所占据的最大宽度
    *
    * @param cell单元格数据
    * @index cell位置
    *
    * @return cell所占据的最大宽度
    */
    private func caculateCellSpaceWidth (cellModel:CJCollectionViewCellModel,indexAtItems index:Int) -> CGFloat {
        
        // 计算单元格cell的实际宽度
        let cellWidth = caculateCellWidth(cellModel)
        
        // 单元格占据的宽度，用于计算该单元格属于哪一行
        var spaceWidth : CGFloat!
        
        // 如果cell的实际宽度等于最大限制宽度，那么cell占据宽度等于最大限制宽度
        if cellWidth == limitWidth {
            
            spaceWidth = cellWidth
        } else {
            
            // 如果单元格cell是数组中第一个，那么不需要+水平间距
            if index == 0 {
                
                spaceWidth = cellWidth
            } else {
                
                let limitWidth2 = limitWidth - cellHorizontalMargin
                
                if cellWidth >= limitWidth2 {
                    
                    // 如果单元格item不是第一个，而且itemWidth大于最大限制宽度-水平间距，那么item占据宽度为最大限制
                    spaceWidth = limitWidth
                } else {
                    
                    // 正常占据
                    spaceWidth = cellWidth + cellHorizontalMargin
                }
            }
        }
        return spaceWidth
    }
    
    /**
    * 计算第一行包含的cell数量
    *
    * @param cellModels 单元格数据数组
    *
    * @return 第一行包含的cell数量
    */
    private func caculateCellCountForFirstRow(cellModels:[CJCollectionViewCellModel]) -> Int {
        
        var cellCount: Int   = 0
        
        let widthArray = NSMutableArray()
        
        for (var i=0; i<cellModels.count; i++) {
            
            let spaceWidth = caculateCellSpaceWidth(cellModels[i], indexAtItems: i)
            widthArray.addObject(spaceWidth)
            
            let sumArray = NSArray(array: widthArray)
            let sum:CGFloat = sumArray.valueForKeyPath("@sum.self") as! CGFloat
            
            if sum <= limitWidth {
                
                cellCount++
            } else {
                break
            }
        }
        
        return cellCount
    }
    
    /**
    * 计算每一行包含的cell数量数组
    * @param cellModels 单元格数据数组
    *
    * @return 每一行包含的cell数量数组
    */
    private func caculateCellCountForEveryRow(var cellModels:[CJCollectionViewCellModel]) -> [Int] {
        
        var resultArray = [Int]()
        let tempArray = NSMutableArray(array: cellModels)
        
        let cellCount = caculateCellCountForFirstRow(cellModels)
        resultArray.append(cellCount)
        
        for item in tempArray {
            
            let cellCount = caculateCellCountForFirstRow(cellModels)
            
            if cellModels.count != cellCount {
                
                cellModels.removeRange(Range(start: 0, end: cellCount))
                
                let cellCount = caculateCellCountForFirstRow(cellModels)
                resultArray.append(cellCount)
            }
        }
        return resultArray
    }
    
    // MARK: - 业务
    
    /**
    * 重新计算
    */
    private func caculate() {
        
        cellCountDictionary = caculateCellCountForEveryRowInSection()
        defaultCellCountForSectionDictionary = caculateDefaultCellCountForSection()
        isShowMoreBtnDictionary = caculateIsShowMoreBtn()
    }
    
    /**
    * 计算每个分类每一行包含的cell数量字典
    *
    * @return 每个分类每一行包含的cell数量字典
    */
    private func caculateCellCountForEveryRowInSection() -> [CJCollectionViewHeaderModel:[Int]] {
        
        var resultDic = [CJCollectionViewHeaderModel:[Int]]()
        
        for key in dataSource.keys {
            
            let tempArray = caculateCellCountForEveryRow(dataSource[key]!)
            resultDic[key] = tempArray
        }
        return resultDic
    }
    
    /**
    * 计算每个分类下默认显示的行数包含cell的数量字典
    *
    * @return 每个分类下默认显示的行数包含cell的数量字典
    */
    private func caculateDefaultCellCountForSection() -> [CJCollectionViewHeaderModel:Int] {
        
        var resultDic = [CJCollectionViewHeaderModel:Int]()
        
        for key in cellCountDictionary.keys.array {
            
            var sum: Int = 0
            let cellCountForEveryRowArray = cellCountDictionary[key]!
            
            for (var i=0; i<cellCountForEveryRowArray.count; i++) {
                
                if i < defaultRows {
                    
                    sum += cellCountForEveryRowArray[i]
                } else {
                    
                    break
                }
            }
            resultDic[key] = sum
        }
        
        return resultDic
    }
    
    /**
    * 计算每个分类下是否应该显示更多按钮字典
    *
    * @return 每个分类下是否应该显示更多按钮字典
    */
    private func caculateIsShowMoreBtn() -> [CJCollectionViewHeaderModel: Bool] {
        
        var resultDic = [CJCollectionViewHeaderModel: Bool]()
        
        for key in cellCountDictionary.keys.array {
            
            let cellCountForEveryRowArray = cellCountDictionary[key]!
            
            if cellCountForEveryRowArray.count > defaultRows {
                
                resultDic[key] = true
            } else {
                
                resultDic[key] = false
            }
        }
        
        return resultDic
    }
    
}
