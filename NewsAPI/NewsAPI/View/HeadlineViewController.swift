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
        // call api request to get headlines
        headlineViewModel?.queryToGetHeadLines()
    }
}
