//
//  NewsServiceSpy.swift
//  CryptoListTests
//
//  Created by abdul ahad  on 14/02/22.
//

@testable import CryptoList

class NewsServiceSpy: NewsLoader {
    
    private(set) var loadNewsCount = 0
    private let result: Result<[News], Error>
    
    init(result: [News] = []){
        self.result = .success(result)
    }
    
    init(result: Error){
        self.result = .failure(result)
    }
    
    func load(completion: @escaping (Result<[News], Error>) -> Void) {
        loadNewsCount += 1
        completion(result)
    }
    
}
