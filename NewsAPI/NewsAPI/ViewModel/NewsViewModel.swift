//
//  NewsViewModel.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

/* The base class for HeadlineViewModel & CustomNewsViewModel*/

import RxSwift
class NewsViewModel {
    weak var newsAPIRequestdelegate: NewsAPIRequestDelegate?
    let disposeBag = DisposeBag() // hold RxSwift threads
    var articles: [Article]?    
    init(delegate: NewsAPIRequestDelegate){
        newsAPIRequestdelegate = delegate        
    }
    
}
