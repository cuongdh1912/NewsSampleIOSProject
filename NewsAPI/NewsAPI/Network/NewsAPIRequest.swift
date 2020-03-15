//
//  NewsAPIRequest.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
/* Call API requests to get news
    -Use RxAlamofire framwork
 */
import Foundation
import RxSwift
import RxAlamofire
class NewsAPIRequest{
    static let shared = NewsAPIRequest()
    let disposeBag = DisposeBag() // handle the life of rxswift
    // generate NSError object with error code & message
    static func createError(_ message: String?)->NSError{
        return NSError(domain:"", code: 401, userInfo:[ NSLocalizedDescriptionKey: message ?? ""])
    }
    
    // get news when user select a preference: bitcoin, apple, earthquake, animal
    func getNews(keyWord: String?, page: Int)  -> Observable<(Int, [Article])> {
        var urlString: String = URLQueryData.rootURL
        let pageString = String(page)
        var parameters:[String: String] = [:]
        if let keyWord = keyWord { // query custom news with keyword
            urlString += URLQueryData.customExtension
            // generate dictionary of parameters & values
            parameters = [NewsWithKeywordParameters.keyWord: keyWord, NewsWithKeywordParameters.sortBy: NewsWithKeywordValues.sortBy]
            if let from = getLast7Date() {
                parameters[NewsWithKeywordParameters.from] = from
            }
        }else { // for headlines
            urlString += URLQueryData.headlineExtension
            parameters = [HeadLineParameters.country: HeadLineValues.country, HeadLineParameters.category: HeadLineValues.category]
        }
         
        parameters[HeadLineParameters.page] = pageString
        parameters[HeadLineParameters.apiKey] = HeadLineValues.apiKey
        
        
        return doQuerying(urlString: urlString, parameters: parameters)
    }
    // query api to get all news with urlString & parameters
    func doQuerying(urlString: String, parameters: [String: String]) -> Observable<(Int, [Article])> {
        // generate "get" url with parameters
        var url = urlString
        for (key, value) in parameters {
            url += key + "=" + value + "&"
        }
        if url.last == "&" {
            url.removeLast() // remove &
        }
        // call get api with url
        return Observable.create {[unowned self] observer in
            RxAlamofire.requestJSON(.get, url)
                .subscribe(onNext: {(r, json) in // if smt responds
                    let message = "Get news failded! Please try again"
                    if let dict = json as? [String: Any] {
                        if let status = dict[JSONDataKeys.status] as? String {
                            if status == "ok"{
                                if let articles = dict[JSONDataKeys.articles], let newsList = JSONParser.shared.createNewsByJSONArray(objectArray: articles), let totalResults = dict[JSONDataKeys.totalResults] as? Int {
                                    observer.onNext((totalResults, newsList))
                                }
                                else{
                                    let error = NewsAPIRequest.createError(message)
                                    observer.onError(error)
                                }
                            }else { // get message
                                if let m = dict[JSONDataKeys.message] as? String {
                                    let error = NewsAPIRequest.createError(m)
                                    observer.onError(error)
                                }
                            }
                        }else{ // not successful show error message
                            let error = NewsAPIRequest.createError(message)
                            observer.onError(error)
                        }
                    }else{ // dict is empty
                        let error = NewsAPIRequest.createError(message)
                        observer.onError(error)
                    }
                }, onError: { error in // if error
                    observer.onError(error)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    func getLast7Date() -> String? {
        var dateComponents = DateComponents()
        dateComponents.setValue(-7, for: .day) // -7 day
        
        let now = Date() // Current date
        let date = Calendar.current.date(byAdding: dateComponents, to: now) // Add the DateComponents
        // convert date to string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = date {
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
