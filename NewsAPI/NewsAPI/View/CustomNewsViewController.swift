//
//  CustomNewsViewController.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

import UIKit

class CustomNewsViewController: NewsViewController {
    var customNewsViewModel: CustomNewsViewModel? // ViewModel
    override func viewDidLoad() {
        super.viewDidLoad()
        customNewsViewModel = CustomNewsViewModel(delegate: self)
        newsModelView = customNewsViewModel
        // call api request to get headlines
        customNewsViewModel?.queryToGetCustomNews()
    }
    // handle refresh control event
    @objc override func handleRefreshControl() {
        customNewsViewModel?.queryToGetCustomNews()
        // Dismiss the refresh control.
        DispatchQueue.main.async {[unowned self] in
            self.tableView?.refreshControl?.endRefreshing()
        }
    }
}

