//
//  URLData.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
/* Data for api request
    -Url constant
    -Parameters
    -Default values
 */
struct URLQueryData {
    static let rootURL = "http://newsapi.org/v2/"
        static let headlineExtension = "top-headlines?"
        static let customExtension = "everything?"
}
// parameters for headline api
struct HeadLineParameters {
    static let country = "country"
    static let category = "category"
    static let apiKey = "apiKey"
    static let page = "page"
}
struct HeadLineValues {
    static let country = "us"
    static let category = "business"
    static let apiKey = "3152eaf4ca1b4b4fbb958555ec42574c"
}
// parameters for custom news api
struct NewsWithKeywordParameters {
    static let keyWord = "q"
    static let from = "from"
    static let sortBy = "sortBy"
}
struct NewsWithKeywordValues {
    static let sortBy = "publishedAt"
}
