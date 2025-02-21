//
//  CoinRankingAPI.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation

protocol CoinRankingAPIProtocol {
    func fetchCoins(offset: Int, limit: Int) async throws -> Coins
    func fetchCoinHistory(id: String, timePeriod: String) async throws -> CoinHistory
}

// MARK: - Network Layer
final class CoinRankingAPI: CoinRankingAPIProtocol {
    private let networkService: NetworkServicing

    init(networkService: NetworkServicing) {
        self.networkService = networkService
    }

    func fetchCoins(offset: Int, limit: Int) async throws -> Coins {
        let request = CoinsRequest(offset: offset, limit: limit)
        return try await networkService.perform(request)
    }

    func fetchCoinHistory(id: String, timePeriod: String) async throws -> CoinHistory {
        let request = HistoryRequest(id: id, timePeriod: timePeriod)
        return try await networkService.perform(request)
    }
}
