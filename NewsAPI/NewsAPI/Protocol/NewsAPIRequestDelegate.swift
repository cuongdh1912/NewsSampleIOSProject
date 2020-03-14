//
//  ReloadTableDelegate.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

import Foundation
protocol NewsAPIRequestDelegate {
    func newsAPIRequestSuccess()
    func newsAPIRequestFailed(error: NSError)
}
