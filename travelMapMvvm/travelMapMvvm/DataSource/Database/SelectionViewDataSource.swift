//
//  SelectionViewDataSource.swift
//  travelMapMvvm
//
//  Created by green on 15/8/31.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

class SelectionViewDataSource: SelectionViewDataSourceProtocol {
    
    // MARK: - 单例
    
    class func shareInstance()->SelectionViewDataSourceProtocol{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:SelectionViewDataSource? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance=SelectionViewDataSource()
        })
        return YRSingleton.instance!
    }
    
    func queryFilterDictionary() -> OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]> {
        
        var dataSource = OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>()
        
        // 旅游月份信息
        let monthHeaderModel    = CJCollectionViewHeaderModel(
            icon: "home_btn_cosmetic",
            title: "旅游月份",
            type: .MultipleChoice,
            isExpend: true,
            isShowClearButton: false,
            height: 38)
        var monthCellModelArray = [CJCollectionViewCellModel]()
        
        for month in MonthEnum.allValues {
            
            monthCellModelArray.append(CJCollectionViewCellModel(icon: nil, title: month.rawValue))
        }
        
        // 攻略主题信息
        let strategyThemeHeaderModel    = CJCollectionViewHeaderModel(
            icon: "home_btn_cosmetic",
            title: "主题", type: .MultipleChoice,
            isExpend: true,
            isShowClearButton: false,
            height: 38)
        var strategyThemeCellModelArray = [CJCollectionViewCellModel]()
        
        for strategyTheme in StrategyThemeEnum.allValues {
            
            strategyThemeCellModelArray.append(CJCollectionViewCellModel(icon: nil, title: strategyTheme.rawValue))
        }
        
        // 攻略分类信息
        let strategyTypeHeaderModel    = CJCollectionViewHeaderModel(
            icon: "home_btn_cosmetic",
            title: "分类",
            type: .MultipleChoice,
            isExpend: true,
            isShowClearButton: false,
            height: 38)
        var strategyTypeCellModelArray = [CJCollectionViewCellModel]()
        
        for strategyType in StrategyTypeEnum.allValues {
            
            strategyTypeCellModelArray.append(CJCollectionViewCellModel(icon: nil, title: strategyType.rawValue))
        }
        
        // 初始化dataSource
        dataSource[monthHeaderModel]            = monthCellModelArray
        dataSource[strategyThemeHeaderModel]    = strategyThemeCellModelArray
        dataSource[strategyTypeHeaderModel]     = strategyTypeCellModelArray
        
        return dataSource
    }
    
    func queryOrderDictionary(cellWidth:CGFloat) -> OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]> {
        
        var dataSource = OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>()
        
        var strategyOrderHeaderModel = CJCollectionViewHeaderModel(icon: nil, title: nil, type: CJCollectionViewHeaderModelTypeEnum.SingleChoice, isExpend: true, isShowClearButton: false, height: 0)
        var strategyOrderCellModels  = [CJCollectionViewCellModel]()
        
        for strategyOrder in StrategyOrderEnum.allValues {
            
            let cellModel   = CJCollectionViewCellModel(icon: nil, title: strategyOrder.rawValue)
            cellModel.width = cellWidth
            
            if strategyOrder == .Default {
                
                cellModel.selected = true
            }
            
            strategyOrderCellModels.append(cellModel)
            
        }
        
        dataSource[strategyOrderHeaderModel] = strategyOrderCellModels
        
        return dataSource
    }
}