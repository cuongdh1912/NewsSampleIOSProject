//
//  NewsViewModel.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

/* The base class for HeadlineViewModel & CustomNewsViewModel*/

import Foundation
import RxSwift
import RxCocoa
class NewsViewModel {
    weak var newsAPIRequestdelegate: NewsAPIRequestDelegate?
    let disposeBag = DisposeBag() // hold RxSwift threads
    var isQueryingFirstPage: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var loadedPage: Int = 0
    var articles: [Article]?
    var currentPreference: String?
    var loadingCompleted = false
    
    init(delegate: NewsAPIRequestDelegate){
        newsAPIRequestdelegate = delegate        
    }
    // save current preference for future using
    func updateCurrentPreference(preference: String?){
        currentPreference = preference
    }
    // calculate the total number of table view's rows
    func getNumberOfRow() -> Int {
        if let count = articles?.count {
            if loadingCompleted || count == 0{ // there is no more news
                return count
            }else {
                return count + 1 // show "Load more" row
            }
        }
        return 0
    }
    // called when user touch "Load more" button
    func loadMorePage() {
        queryToGetNews(keyword: currentPreference)
    }
    // start to get news
    func queryToGetNewsFromBeginning(keyword: String?) {
        loadingCompleted = false
        articles = []
        isQueryingFirstPage.accept(true)
        queryToGetNews(keyword: keyword)
    }
    // call api request to get news with keyword
    func queryToGetNews(keyword: String?) {
        // query api request in other thread
        DispatchQueue.global(qos: .utility).async {[unowned self] in
            NewsAPIRequest.shared.getNews(keyWord: keyword, page: self.loadedPage + 1)
                .subscribe({[weak self] event in
                    switch event {
                    case .next(let (total, list)): // if success
                        if self != nil {
                            if self!.loadedPage == 0 || self!.articles == nil { // beginning
                                self!.articles = list
                            }else { // append articles with list
                                self!.articles = self!.articles! + list
                            }
                            if let count = self!.articles?.count, count >= total { // loading completes
                                self!.loadingCompleted = true
                            }
                            // update table view in main thread (UI)
                            DispatchQueue.main.async { [weak self] in
                              self?.newsAPIRequestdelegate?.newsAPIRequestSuccess()
                            }
                        }
                    case .error(let error): // if failed
                        // show error alert in main thread
                        DispatchQueue.main.async { [weak self] in
                            self?.newsAPIRequestdelegate?.newsAPIRequestFailed(error: error as NSError)
                        }
                    default:
                        break
                    }
                    self?.isQueryingFirstPage.accept(false)
                })
                .disposed(by: self.disposeBag)
        }
    }
}
