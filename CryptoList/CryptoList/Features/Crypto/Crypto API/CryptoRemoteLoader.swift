//
//  CryptoRemoteLoader.swift
//  CryptoList
//
//  Created by ahad on 8/25/22.
//

import Foundation
final class CryptoRemoteLoader: CryptoLoader {
  
    typealias Result = CryptoLoader.Result
    
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
 
    func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(CryptoMapper.map(data: data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

