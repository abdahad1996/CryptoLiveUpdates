//
//  DictionaryExtension.swift
//  CryptoList
//
//  Created by abdul ahad  on 12/02/22.
//

import Foundation

extension Dictionary {
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
    }
    
    func toJSONString() -> String? {
        if let jsonData = jsonData {
            return String(data: jsonData, encoding: .utf8)
        }
        
        return nil
    }
}
