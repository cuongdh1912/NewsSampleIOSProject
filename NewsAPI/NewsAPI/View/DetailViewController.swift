//
//  DetailViewController.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
/* Display news's detail: title, description, photo, resource url
 */
import UIKit
import Kingfisher
class DetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var detailLabel: UILabel?
    @IBOutlet weak var contentLabel: UILabel?
    @IBOutlet weak var publishedDate: UILabel?
    @IBOutlet weak var authorLabel: UILabel?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var imageHeightConstrant: NSLayoutConstraint? // use to adjust the height of image so that it matches its ratio
    
    var article: Article?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let article = article {
            // update title text
            titleLabel?.text = article.title
            // update detail text
            detailLabel?.text = article.detail
            contentLabel?.text = article.content
            publishedDate?.text = article.publishedAt
            var author:String? = nil
            if let a = article.author {
                author = "Author: " + a
            }
            authorLabel?.text = author
            // update image
            if let urlToImage = article.urlToImage, let url = URL(string: urlToImage) {
                imageView?.kf.setImage(with: url){[weak self] result in
                    switch result {
                    case .success(let value):
                        // calculate ratio of image
                        let image = value.image
                        let w = image.size.width
                        let h = image.size.height
                        let ratio = h / w
                        self?.adjustConstraintLayout(ratio)
                    case .failure(let error):
                        print(error)
                    }
                    // refresh imageview
                    self?.imageView?.setNeedsLayout()
                }
            }
        }
    }
    func adjustConstraintLayout(_ ratio: CGFloat){
        if let width = imageView?.frame.size.width {
            imageHeightConstrant?.constant = width * ratio
        }
    }
    // open original news in a webview
    @IBAction func originalNewsButtonClicked(_ sender: Any?){
        if let originalNewsVC = RouteManager.getViewControllerWithId(ViewControllerIds.originalVC) as? OriginalNewsViewController {
            originalNewsVC.urlString = article?.url
            self.navigationController?.pushViewController(originalNewsVC, animated: true)
        }
    }
}
