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
    // query to get headlines
    func getHeadlines() -> Observable<[Article]>{
        let urlString: String = URLQueryData.rootURL + URLQueryData.headlineExtension
        // generate dictionary of parameters & values
        let parameters = [HeadLineParameters.country: HeadLineValues.country, HeadLineParameters.category: HeadLineValues.category, HeadLineParameters.apiKey: HeadLineValues.apiKey]
        return getNews(urlString: urlString, parameters: parameters)
    }
    // get news when user select a preference: bitcoin, apple, earthquake, animal
    func getNewsWithKeyword(keyWord: String)  -> Observable<[Article]> {
        let urlString: String = URLQueryData.rootURL + URLQueryData.customExtension
        // generate dictionary of parameters & values
        var parameters = [NewsWithKeywordParameters.keyWord: keyWord, NewsWithKeywordParameters.sortBy: NewsWithKeywordValues.sortBy, HeadLineParameters.apiKey: HeadLineValues.apiKey]
        if let from = getLast7Date() {
            parameters[NewsWithKeywordParameters.from] = from
        }
        return getNews(urlString: urlString, parameters: parameters)
    }
    // query api to get all news with urlString & parameters
    func getNews(urlString: String, parameters: [String: String]) -> Observable<[Article]> {
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
                        if let status = dict[JSONDataKeys.status] as? String, status == "ok"{
                            if let articles = dict[JSONDataKeys.articles], let newsList = JSONParser.shared.createNewsByJSONArray(objectArray: articles) {
                                observer.onNext(newsList)
                            }
                            else{
                                let error = NewsAPIRequest.createError(message)
                                observer.onError(error)
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
