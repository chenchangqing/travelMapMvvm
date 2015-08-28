//
//  TableViewBindingHelper.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Colin Eberhardt on 15/07/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import ReactiveCocoa

@objc protocol ReactiveView {
  func bindViewModel(viewModel: AnyObject)
}

// a helper that makes it easier to bind to UITableView instances
// see: http://www.scottlogic.com/blog/2014/05/11/reactivecocoa-tableview-binding.html
class TableViewBindingHelper: NSObject, UITableViewDataSource, UITableViewDelegate {
  
  //MARK: Properties
  
  var delegate: UITableViewDelegate?
  
  private let tableView: UITableView
  private let templateCell: UITableViewCell
  private let selectionCommand: RACCommand?
  private var data: [AnyObject]
    private var cellHeight: CGFloat?

  //MARK: Public API
  
  init(tableView: UITableView, sourceSignal: RACSignal, nibName: String, selectionCommand: RACCommand? = nil) {
    self.tableView = tableView
    self.data = []
    self.selectionCommand = selectionCommand
    
    let nib = UINib(nibName: nibName, bundle: nil)

    // create an instance of the template cell and register with the table view
    templateCell = nib.instantiateWithOwner(nil, options: nil)[0] as! UITableViewCell
    tableView.registerNib(nib, forCellReuseIdentifier: templateCell.reuseIdentifier!)
    
    super.init()
    
    sourceSignal.subscribeNext {
      (d:AnyObject!) -> () in
      self.data = d as! [AnyObject]
      self.tableView.reloadData()
    }
    
    tableView.dataSource = self
    tableView.delegate = self
  }
    
    init(tableView: UITableView, sourceSignal: RACSignal, reuseIdentifier: String, cellHeight: CGFloat, selectionCommand: RACCommand? = nil) {
        
        self.tableView = tableView
        self.data = []
        self.selectionCommand = selectionCommand
        self.cellHeight = cellHeight
        
        templateCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! UITableViewCell
        
        super.init()
        
        sourceSignal.subscribeNext {
            (d:AnyObject!) -> () in
            self.data = d as! [AnyObject]
            self.tableView.reloadData()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }
  
  //MARK: Private
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let item: AnyObject = data[indexPath.row]
    let cell = tableView.dequeueReusableCellWithIdentifier(templateCell.reuseIdentifier!) as! UITableViewCell
    if let reactiveView = cell as? ReactiveView {
      reactiveView.bindViewModel(item)
    }
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
    if let cellHeight=cellHeight {
        
        return cellHeight
    }
    return templateCell.bounds.size.height
  }
  
  func tableView(tableView: UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath){
    if selectionCommand != nil {
      selectionCommand?.execute(data[indexPath.row])
    }
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    if self.delegate?.respondsToSelector(Selector("scrollViewDidScroll:")) == true {
      self.delegate?.scrollViewDidScroll?(scrollView);
    }
  }
}
