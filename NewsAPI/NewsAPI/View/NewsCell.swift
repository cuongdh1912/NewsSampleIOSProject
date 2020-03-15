//
//  NewsCell.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
/* A custom table view cell for news cell*/
import UIKit
import Kingfisher
class NewsCell: UITableViewCell {
    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var photo: UIImageView?
    // update title & photo with article
    func update(article: Article){
        title?.text = article.title
        photo?.kf.indicatorType = .activity
        if let urlToImage = article.urlToImage, let url = URL(string: urlToImage) {
            photo?.kf.setImage(with: url)
        }else{
            photo?.image = UIImage(named: ImageNames.placeHolder)
        }
    }
}
