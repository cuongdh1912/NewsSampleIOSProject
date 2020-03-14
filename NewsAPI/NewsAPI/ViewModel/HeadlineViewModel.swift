//
//  HeadlineViewModel.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
import Foundation
class HeadlineViewModel: NewsViewModel {    
    func queryToGetHeadLines() {        
        // query api request in other thread
        DispatchQueue.global(qos: .utility).async {
            NewsAPIRequest.shared.getHeadlines()
                .subscribe({[weak self] event in
                    switch event {
                    case .next(let list): // if success
                        self?.articles = list
                        // update table view in main thread
                        DispatchQueue.main.async { [weak self] in
                          self?.newsAPIRequestdelegate?.newsAPIRequestSuccess()
                        }
                    case .error(let error): // if failed
                        // show error alert in main thread
                        DispatchQueue.main.async { [weak self] in
                            self?.newsAPIRequestdelegate?.newsAPIRequestFailed(error: error as NSError)
                        }
                    default:
                        break
                    }
                })
                .disposed(by: self.disposeBag)
        }
    }
}

