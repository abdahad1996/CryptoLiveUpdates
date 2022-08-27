//
//  CryptoListViewModel.swift
//  CryptoList
//
//  Created by abdul ahad  on 19/02/22.
//

import Foundation

class CryptoListViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let service: CryptoLoader
    private var onCoinsLoadObservers: [Observer<[Coin]>] = []
    var onCoinsError: Observer<Error>?
    var onCoinsLoading: Observer<Bool>?

    func add(onCoinsLoad:@escaping Observer<[Coin]>){
        onCoinsLoadObservers.append(onCoinsLoad)
    }
    init(service: CryptoLoader){
        self.service = service
    }
    
    func fetchCoins(){
        onCoinsLoading?(true)
        service.load { [weak self] result in
         self?.onCoinsLoading?(false)

            switch result {
            case let .success(coins):
                self?.onCoinsLoadObservers.forEach { $0(coins) }
//                self?.onCoinsLoad?(coins)
            case let .failure(error):
                self?.onCoinsError?(error)
            }
        }
        
    }
}
