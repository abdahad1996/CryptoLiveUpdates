//
//  NewsService.swift
//  CryptoList
//
//  Created by abdul ahad  on 12/02/22.
//

import Foundation

protocol NewsLoader {
    typealias Result = Swift.Result<[News], Error>
    func load(completion: @escaping (Result) -> Void)
}

 
