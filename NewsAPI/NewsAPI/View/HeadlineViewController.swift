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
    let ReusedCellId = "ReusedCellIdHeadLines"
    override func viewDidLoad() {
        super.viewDidLoad()
        reusedTableViewCellId = ReusedCellId
        headlineViewModel = HeadlineViewModel(delegate: self)
        newsModelView = headlineViewModel
        // call api request to get headlines
        headlineViewModel?.queryToGetHeadLines()
    }
}
