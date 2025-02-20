//
//  Endpoint.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation

extension CoinRankingAPI {
    enum Endpoint {
        case coins(offset: Int, limit: Int)
        case coinDetail(id: String)
        case coinHistory(id: String, timePeriod: String)
        
        var path: String {
            switch self {
            case .coins:
                return "/coins"
            case .coinDetail(let id):
                return "/coin/\(id)"
            case .coinHistory(let id, _):
                return "/coin/\(id)/history"
            }
        }
    }
}
