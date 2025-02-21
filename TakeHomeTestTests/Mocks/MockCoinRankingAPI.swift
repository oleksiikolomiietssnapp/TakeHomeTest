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
    static var mockCoins: Coins = Coins(coins: [])
    static var mockHistory: CoinHistory?
    static var mockError: Error?
    static var needsDelay: Bool = false

    static func reset() {
        mockError = nil
        mockHistory = nil
        needsDelay = false
        mockCoins = .init(coins: [])
    }

    static func fetchCoins(offset: Int, limit: Int) async throws -> Coins {
        if needsDelay {
            try await Task.sleep(nanoseconds: 100_000_000)
        }

        if let error = mockError {
            throw error
        }

        return mockCoins
    }

    static func fetchCoinHistory(id: String, timePeriod: String) async throws -> CoinHistory {
        if needsDelay {
            try await Task.sleep(nanoseconds: 100_000_000)
        }

        if let error = mockError {
            throw error
        }
        return mockHistory ?? CoinHistory(change: 0.0, points: [])
    }
}
