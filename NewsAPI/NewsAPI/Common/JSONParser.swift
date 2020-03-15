//
//  JSONParser.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

struct JSONDataKeys{
    static let status = "status"
    static let articles = "articles"
    static let title = "title"
    static let detail = "description"
    static let content = "content"
    static let author = "author"
    static let publishedAt = "publishedAt"
    static let url = "url"
    static let urlToImage = "urlToImage"
}
class JSONParser {
    static let shared = JSONParser()
    func createNewsByJSONArray(objectArray: Any?) -> [Article]?{
        guard let objects = objectArray as?  [[String: Any?]] else {return nil}
        var articles: [Article] = []
        for object in objects {
            let article = Article()
            article.title = object[JSONDataKeys.title] as? String
            article.detail = object[JSONDataKeys.detail] as? String
            article.content = object[JSONDataKeys.content] as? String
            article.author = object[JSONDataKeys.author] as? String
            article.publishedAt = object[JSONDataKeys.publishedAt] as? String
            article.url = object[JSONDataKeys.url] as? String
            article.urlToImage = object[JSONDataKeys.urlToImage] as? String
            articles.append(article)
        }
        return articles
    }
}
