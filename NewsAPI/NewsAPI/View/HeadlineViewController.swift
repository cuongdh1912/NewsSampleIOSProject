//
//  HeadlineViewController.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

import UIKit
class HeadlineViewController: NewsViewController {
    var headlineViewModel: HeadlineViewModel? // ViewModel
    override func viewDidLoad() {
        super.viewDidLoad()
        headlineViewModel = HeadlineViewModel(delegate: self)
        newsModelView = headlineViewModel
        // call api request to get headlines
        headlineViewModel?.queryToGetHeadLines()
    }
    // handle refresh control event
    @objc override func handleRefreshControl() {
        headlineViewModel?.queryToGetHeadLines()
        // Dismiss the refresh control.
        DispatchQueue.main.async {[unowned self] in
            self.tableView?.refreshControl?.endRefreshing()
        }
    }
}
