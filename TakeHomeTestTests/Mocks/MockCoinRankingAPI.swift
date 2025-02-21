//
//  MockCoinRankingAPI.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import Foundation
@testable import TakeHomeTest

final class MockCoinRankingAPI: CoinRankingAPIProtocol {
    static var mockCoins: Coins = Coins(coins: [])
    static var shouldThrowError = false
    
    static func fetchCoins(offset: Int, limit: Int) async throws -> Coins {
        if shouldThrowError {
            throw NSError(domain: "test", code: 1)
        }
        return mockCoins
    }
}
