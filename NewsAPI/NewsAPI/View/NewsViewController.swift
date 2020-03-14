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
