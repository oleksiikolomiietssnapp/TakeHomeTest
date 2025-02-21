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

#if DEBUG
// Testing helpers
extension CoinRankingAPI.Endpoint: Equatable {
    static func == (lhs: CoinRankingAPI.Endpoint, rhs: CoinRankingAPI.Endpoint) -> Bool {
        switch (lhs, rhs) {
        case (.coins, .coins): return true
        case (.coinDetail, .coinDetail): return true
        case (.coinHistory, .coinHistory): return true
        default: return false
        }
    }
}
#endif
