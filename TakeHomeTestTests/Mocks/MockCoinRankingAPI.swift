//
//  MockCoinRankingAPI.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import Foundation

@testable import TakeHomeTest

enum MockError: Error {
    case testError
}

final class MockCoinRankingAPI: CoinRankingAPIProtocol {
    var mockCoins: Coins = Coins(coins: [])
    var mockHistory: CoinHistory?
    var mockError: Error?
    var needsDelay: Bool = false

    func fetchCoins(offset: Int, limit: Int) async throws -> Coins {
        if needsDelay {
            try await Task.sleep(nanoseconds: 100_000_000)
        }

        if let error = mockError {
            throw error
        }

        return mockCoins
    }

    func fetchCoinHistory(id: String, timePeriod: String) async throws -> CoinHistory {
        if needsDelay {
            try await Task.sleep(nanoseconds: 100_000_000)
        }

        if let error = mockError {
            throw error
        }
        return mockHistory ?? CoinHistory(change: 0.0, points: [])
    }
}
