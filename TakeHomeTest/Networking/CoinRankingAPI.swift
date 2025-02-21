//
//  CoinRankingAPI.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation

protocol CoinRankingAPIProtocol {
    static func fetchCoins(offset: Int, limit: Int) async throws -> Coins
}

// MARK: - Network Layer
final class CoinRankingAPI: CoinRankingAPIProtocol {
    static private let baseURL = "https://api.coinranking.com/v2"
    static private let apiKey = "coinranking83e3d43398a8a8bb4eee083cc0f9b3b1665c5e616ffa0d14"
    private static let networkService = NetworkService(baseURL: baseURL, apiKey: apiKey)

    static func fetchCoins(offset: Int, limit: Int) async throws -> Coins {
        let request = CoinsRequest(offset: offset, limit: limit)
        return try await networkService.perform(request)
    }

    static func fetchCoinHistory(id: String, timePeriod: String) async throws -> CoinHistory {
        let request = HistoryRequest(id: id, timePeriod: timePeriod)
        return try await networkService.perform(request)
    }
}
