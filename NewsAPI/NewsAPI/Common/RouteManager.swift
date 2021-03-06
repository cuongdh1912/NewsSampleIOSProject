//
//  RouteManager.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
import UIKit
struct ViewControllerIds {
    static let detailVC = "DetailViewController"
    static let originalVC = "OriginalNewsViewController"
}
class RouteManager{
    // load viewcontroller from main storyboard by viewcontroller id
    static func getViewControllerWithId(_ viewControllerId: String) -> UIViewController?{
        return UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: viewControllerId)
    }
    static func showAlert(message: String?, parrent: UIViewController) {
        // show error alert
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertText.okText, style: .cancel, handler: nil))
        parrent.present(alert, animated: true)
    }
}
