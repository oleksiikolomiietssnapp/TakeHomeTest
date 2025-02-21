//
//  CoinsRequest.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation

// MARK: - API Requests
extension CoinRankingAPI {
    struct CoinsRequest: APIRequest {
        typealias Response = Coins

        let offset: Int
        let limit: Int
        var endpoint: Endpoint { .coins(offset: 0, limit: 0) }

        var queryItems: [URLQueryItem] {
            [
                URLQueryItem(name: "offset", value: "\(offset)"),
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "orderBy", value: "price"),
                URLQueryItem(name: "orderDirection", value: "desc"),
                URLQueryItem(name: "timePeriod", value: "24h")
            ]
        }
    }

    struct HistoryRequest: APIRequest {
        typealias Response = CoinHistory

        let id: String
        let timePeriod: String
        var endpoint: Endpoint { .coinHistory(id: id, timePeriod: timePeriod) }

        var queryItems: [URLQueryItem] {
            [
                URLQueryItem(name: "timePeriod", value: timePeriod)
            ]
        }
    }
}
