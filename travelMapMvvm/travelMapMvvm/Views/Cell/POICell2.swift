//
//  POICell2.swift
//  travelMapMvvm
//
//  Created by green on 15/9/18.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit

class POICell2: UITableViewCell, ReactiveView {
    
    // MARK: - UI
    
    @IBOutlet weak var poiPic: UIImageView!
    @IBOutlet weak var poiNameL: UILabel!
    @IBOutlet weak var poiTypeL: UILabel!
    @IBOutlet weak var countryL: UILabel!
    @IBOutlet weak var cityEnNameL: UILabel!
    
    // MARK: - View Model
    
    private var poiImageViewModel: ImageViewModel!

    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置View Model
        poiImageViewModel = ImageViewModel(urlString: nil, defaultImage:UIImage(named: "defaultImage.jpg")!)
        
        // 绑定View Model
        RACObserve(poiImageViewModel, "image") ~> RAC(self.poiPic,"image")
        
        // 重置图片
        self.rac_prepareForReuseSignal.subscribeNext { (any:AnyObject!) -> Void in
            
            self.poiPic.image = nil
        }
    }
    
    // MARK: - ReactiveView
    
    func bindViewModel(viewModel: AnyObject) {
        
        if let poiModel = viewModel as? POIModel {
            
            self.poiNameL.text      = poiModel.poiName
            self.cityEnNameL.text   = poiModel.cityEnName
            self.countryL.text      = poiModel.country
            self.poiTypeL.text      = poiModel.poiType?.rawValue
            
            self.poiImageViewModel.urlString = poiModel.poiPicUrl
            self.poiImageViewModel.downloadImageCommand.execute(nil)
        }
        
        if let cityModel = viewModel as? CityModel {
            
            self.poiNameL.text      = cityModel.cityName
            self.cityEnNameL.text   = cityModel.cityEnName
            self.countryL.text      = cityModel.country
            self.poiTypeL.text      = "城市"
            
            self.poiImageViewModel.urlString = cityModel.cityPicUrl
            self.poiImageViewModel.downloadImageCommand.execute(nil)
        }
    }

}
