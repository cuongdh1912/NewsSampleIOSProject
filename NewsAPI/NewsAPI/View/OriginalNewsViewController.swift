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
    var urlString: String?
    @IBOutlet var webkit: WKWebView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // convert urlString to url, then open url in webview
        if let urlString = urlString, let url = URL(string: urlString) {
            let urlRequest = URLRequest(url: url)
            webkit?.load(urlRequest)
        }
    }
}
