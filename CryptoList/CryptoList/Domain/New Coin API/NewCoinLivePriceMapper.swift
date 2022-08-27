//
//  NewCryptoLivePriceMapper.swift
//  CryptoList
//
//  Created by ahad on 8/23/22.
//

import Foundation


enum NewCoinLivePriceMapper {
    
    private struct Response:Decodable {
        let PRICE: Double
        let FROMSYMBOL: String

    }
    static func map(_ data: Data) throws -> NewCoinPrice {
        let response = try JSONDecoder().decode(Response.self, from: data)
        return NewCoinPrice(symbol: response.FROMSYMBOL, price: response.PRICE)
    }
}
