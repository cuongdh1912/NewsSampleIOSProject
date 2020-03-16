//
//  HeadlineViewController.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

import UIKit
class HeadlineViewController: NewsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // call api request to get headlines
        newsModelView?.queryToGetNewsFromBeginning(keyword: nil)
    }
    // handle refresh control event
    @objc override func handleRefreshControl() {
        super.handleRefreshControl()
        newsModelView?.queryToGetNewsFromBeginning(keyword: nil)        
    }
}
