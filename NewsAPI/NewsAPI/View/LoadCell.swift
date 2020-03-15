//
//  LoadCell.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/15/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
/* for load cell */
import UIKit
class LoadCell: UITableViewCell {
    weak var newsViewModel: NewsViewModel?
    @IBAction func loadButtonClicked(_ sender: Any?) {
        newsViewModel?.loadMorePage()
    }

}
