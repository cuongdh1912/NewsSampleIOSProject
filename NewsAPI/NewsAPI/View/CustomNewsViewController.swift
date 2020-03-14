//
//  CustomNewsViewController.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

import UIKit

class CustomNewsViewController: NewsViewController {
    let ReusedCellId = "ReusedCellIdCustomNews"
    override func viewDidLoad() {
        super.viewDidLoad()
        reusedTableViewCellId = ReusedCellId
    }

}

