//
//  NewsViewController.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

import UIKit
class NewsViewController: UIViewController {
    @IBOutlet var tableView: UITableView?
    var newsModelView: NewsViewModel?
    var reusedTableViewCellId = "ReusedCellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        // add pull refresh to table view
        configureRefreshControl()
    }
    func configureRefreshControl () {
       // Add the refresh control to your UIScrollView object.
       tableView?.refreshControl = UIRefreshControl()
       tableView?.refreshControl?.addTarget(self, action:
                                          #selector(handleRefreshControl),
                                          for: .valueChanged)
    }
    @objc func handleRefreshControl() {
       
    }
}
// implement NewsAPIRequestDelegate method to reload tableview
extension NewsViewController: NewsAPIRequestDelegate {
    func newsAPIRequestSuccess() {
        // refresh table view
        tableView?.reloadData()
    }
    func newsAPIRequestFailed(error: NSError) {
        // show error alert
        let alert = UIAlertController(title: AlertText.APIQueryFailedTitle, message: error.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertText.okText, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
// implement tableview delegate, datasource
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModelView?.articles?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reusedTableViewCellId ?? "") as? NewsCell, let article = newsModelView?.articles?[indexPath.row]{
            cell.update(article: article)
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let article = newsModelView?.articles?[indexPath.row] {
            if let detailVC = RouteManager.getViewControllerWithId(ViewControllerIds.detailVC) as? DetailViewController {
                detailVC.article = article
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
}
