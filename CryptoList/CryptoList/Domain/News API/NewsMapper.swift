//
//  NewsMapper.swift
//  CryptoList
//
//  Created by abdul ahad  on 13/02/22.
//

import Foundation

enum NewsMapper {
    struct NewsRootResponse: Codable {
        let data: [NewsResponse]
        
        private enum CodingKeys: String, CodingKey {
            case data = "Data"
        }
        
        var news : [News] {
            data.map{ News(source: $0.source, title: $0.title, body: $0.body, url: $0.url)}
        }
    }
    
    struct NewsResponse: Codable {
        let title: String
        let source: String
        let body: String
        let url: URL
    }
    
    private static var statusCode200: Int { return 200 }
    
    static func map(data: Data, response: HTTPURLResponse) -> NewsLoader.Result {
        guard response.statusCode == statusCode200, let data = try? JSONDecoder().decode(NewsRootResponse.self, from: data) else {
            return .failure(NewsRemoteLoader.Error.invalidData)
        }
        return .success(data.news)
    }
}
