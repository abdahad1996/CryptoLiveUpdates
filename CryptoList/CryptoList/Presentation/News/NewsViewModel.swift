//
//  NewsViewModel.swift
//  CryptoList
//
//  Created by abdul ahad  on 18/02/22.
//

import Foundation

class NewsViewModel {
    var service: NewsLoader?
    
    init(service: NewsLoader){
        self.service = service
    }
    
    typealias Observer<T> = (T) -> Void
    
    var onNewsLoad: Observer<[News]>?
    var onNewsError: Observer<Error>?
    
    func fetchNews(){
        service?.load { [weak self] result in
            switch result {
            case let .success(news):
                self?.onNewsLoad?(news)
            case let .failure(error):
                self?.onNewsError?(error)
            }
        }
    }
}
