//
//  CryptoService.swift
//  CryptoList
//
//  Created by abdul ahad  on 11/02/22.
//

import Foundation

protocol CryptoLoader {
    typealias Result = Swift.Result<[Coin], Error>
    
    func load(completion: @escaping (Result) -> Void)
}


 
