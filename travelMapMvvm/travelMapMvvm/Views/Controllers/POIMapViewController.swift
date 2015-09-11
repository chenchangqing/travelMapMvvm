//
//  POIMapViewController.swift
//  travelMapMvvm
//
//  Created by green on 15/9/11.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import UIKit
import ReactiveCocoa

class POIMapViewController: UIViewController {
    
    var poiMapViewModel: POIMapViewModel!   // view model

    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(poiMapViewModel)
    }

}
