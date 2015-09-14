//
//  POIDetailViewController+TableView.swift
//  travelMapMvvm
//
//  Created by green on 15/9/14.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation
import UIKit
import GONMarkupParser

extension POIDetailViewController : UITableViewDataSource {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.poiDetailViewModel.comments.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! UITableViewCell
        
        // 解决模拟器越界 避免设置数据与reloadData时间差引起的错误
        if indexPath.row < self.poiDetailViewModel.comments.count {
            
            let item: AnyObject = self.poiDetailViewModel.comments.keys[indexPath.row]
            if let reactiveView = cell as? ReactiveView {
                reactiveView.bindViewModel(item)
            }
            //            println(indexPath)
        } else {
            
            //            print(indexPath)
            //            print("-越界\n")
        }
        
        return cell
    }
}

extension POIDetailViewController: UITableViewDelegate {

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return CGFloat(self.poiDetailViewModel.comments[self.poiDetailViewModel.comments.keys[indexPath.row]]!.integerValue)
    }
}
