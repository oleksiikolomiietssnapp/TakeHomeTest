//
//  CoinRankingAPITests.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import XCTest

@testable import TakeHomeTest

final class CoinRankingAPITests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var sut: CoinRankingAPI!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = CoinRankingAPI(networkService: mockNetworkService)
    }

    override func tearDown() {
        mockNetworkService = nil
        sut = nil
        super.tearDown()
    }

    func testFetchCoinsSuccess() async throws {
        // Given
        let expectedCoins = Coins(coins: [
            Coin.fake(id: "test-uuid", name: "Bitcoin", symbol: "BTC")
        ])
        mockNetworkService.mockResult = expectedCoins

        // When
        let result = try await sut.fetchCoins(offset: 0, limit: 10)

        // Then
        XCTAssertEqual(mockNetworkService.performCallCount, 1)
        XCTAssertEqual(result.coins.count, 1)
        XCTAssertEqual(result.coins.first?.uuid, "test-uuid")

        let request = mockNetworkService.lastRequest as? CoinRankingAPI.CoinsRequest
        XCTAssertEqual(request?.endpoint, .coins(offset: 0, limit: 10))
        XCTAssertEqual(request?.queryItems.first { $0.name == "offset" }?.value, "0")
        XCTAssertEqual(request?.queryItems.first { $0.name == "limit" }?.value, "10")
    }

    func testFetchCoinHistorySuccess() async throws {
        // Given
        let expectedHistory = CoinHistory(
            change: 10.0,
            points: [CoinHistoryPoint.fake(timestamp: 1000, price: 100)]
        )
        mockNetworkService.mockResult = expectedHistory

        // When
        let result = try await sut.fetchCoinHistory(id: "test-id", timePeriod: "24h")

        // Then
        XCTAssertEqual(mockNetworkService.performCallCount, 1)
        XCTAssertEqual(result.change, 10.0)
        XCTAssertEqual(result.points.count, 1)

        let request = mockNetworkService.lastRequest as? CoinRankingAPI.HistoryRequest
        XCTAssertEqual(request?.endpoint, .coinHistory(id: "test-id", timePeriod: "24h"))
        XCTAssertEqual(request?.queryItems.first { $0.name == "timePeriod" }?.value, "24h")
    }

    func testNetworkError() async {
        // Given
        mockNetworkService.mockError = MockNetworkError.testError

        // Then
        do {
            _ = try await sut.fetchCoins(offset: 0, limit: 10)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is MockNetworkError)
        }
    }
}
