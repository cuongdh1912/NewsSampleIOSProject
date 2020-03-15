//
//  OriginalNewsViewController.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

import UIKit
import WebKit
class OriginalNewsViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    var urlString: String?
    @IBOutlet var webkit: WKWebView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // show activity indicator for waiting loading website
        webkit?.navigationDelegate = self
        // convert urlString to url, then open url in webview
        if let urlString = urlString, let url = URL(string: urlString) {
            let urlRequest = URLRequest(url: url)
            webkit?.load(urlRequest)
            activityIndicator?.startAnimating()
        }else {
            hideActivityIndicator()
        }
    }
    func hideActivityIndicator(){
        activityIndicator?.stopAnimating()
        activityIndicator?.isHidden = true
    }
}
extension OriginalNewsViewController: WKNavigationDelegate {
    // hide activity indicator when webview loading completes
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideActivityIndicator()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideActivityIndicator()
    }
}
