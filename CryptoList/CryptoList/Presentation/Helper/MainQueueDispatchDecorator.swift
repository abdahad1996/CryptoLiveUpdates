//
//  MainQueueDispatchDecorator.swift
//  CryptoList
//
//  Created by abdul ahad  on 26/06/22.
//

import Foundation

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}

extension MainQueueDispatchDecorator: CryptoLoader where T == CryptoLoader {
    func load(completion: @escaping (CryptoLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: NewsLoader where T == NewsLoader {
    func load(completion: @escaping (NewsLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

 
