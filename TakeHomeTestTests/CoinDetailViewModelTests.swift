//
//  MockCoinRankingAPI.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import XCTest

@testable import TakeHomeTest

final class CoinDetailViewModelTests: XCTestCase {
    var sut: CoinDetailViewModel!
    let testCoin = Coin.fake(id: "test-uuid", name: "Bitcoin", symbol: "BTC")
    private var api: MockCoinRankingAPI!

    override func setUp() {
        super.setUp()
        api = MockCoinRankingAPI()
        sut = CoinDetailViewModel(
            coin: testCoin,
            api: api
        )
    }

    override func tearDown() {
        sut = nil
        api = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests

    func testInitialization() {
        XCTAssertEqual(sut.coin.uuid, testCoin.uuid)
        XCTAssertEqual(sut.selectedTimeframe, .month)
        XCTAssertNil(sut.selectedPoint)
        XCTAssertNotNil(sut.coinHistory)
        XCTAssertEqual(sut.coinHistory?.points.count, 0)
    }

    func testTimeframesAvailability() {
        XCTAssertEqual(sut.timeframes, Timeframe.allCases)
    }

    // MARK: - Data Fetching Tests

    func testSuccessfulDataFetch() async {
        // Given
        let mockPoints = [
            CoinHistoryPoint.fake(timestamp: 1000, price: 100),
            CoinHistoryPoint.fake(timestamp: 2000, price: 200),
        ]
        let mockHistory = CoinHistory(change: 10.0, points: mockPoints)
        api.mockHistory = mockHistory

        // When
        await sut.fetchChartData()

        // Then
        XCTAssertEqual(sut.coinHistory?.points.count, 2)
        XCTAssertEqual(sut.coinHistory?.change, 10.0)
        XCTAssertFalse(sut.isLoading)
    }

    func testFailedDataFetch() async {
        // Given
        api.mockError = MockError.testError

        // When
        await sut.fetchChartData()

        // Then
        XCTAssertNil(sut.coinHistory)
        XCTAssertFalse(sut.isLoading)
    }

    func testLoadingState() async {
        // Given
        let expectation = XCTestExpectation(description: "Loading state changes")

        // When
        api.needsDelay = true

        Task {
            await sut.fetchChartData()
            expectation.fulfill()
        }

        // Wait for MainActor to update isLoading to true
        try? await Task.sleep(nanoseconds: 10_000_000)

        // Then
        XCTAssertTrue(sut.isLoading)
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - Timeframe Tests

    func testTimeframeUpdate() async {
        // Given
        let expectation = XCTestExpectation(description: "Timeframe update")
        var fetchCount = 0

        // When
        Task {
            sut.updateTimeframe(.day)
            fetchCount += 1
            expectation.fulfill()
        }

        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.selectedTimeframe, .day)
        XCTAssertGreaterThan(fetchCount, 0)
    }

    func testTimeframeDidSetTriggersFetch() async {
        // Given
        let expectation = XCTestExpectation(description: "Timeframe didSet")
        let mockPoints = [CoinHistoryPoint.fake(timestamp: 1000, price: 100)]
        let mockHistory = CoinHistory(change: 5.0, points: mockPoints)
        api.mockHistory = mockHistory

        // When
        Task {
            sut.selectedTimeframe = .week
            try await Task.sleep(nanoseconds: 100_000_000)
            expectation.fulfill()
        }

        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.coinHistory?.points.count, 1)
        XCTAssertEqual(sut.coinHistory?.change, 5.0)
    }

    // MARK: - Selected Point Tests

    func testSelectedPointUpdate() {
        // Given
        let point = CoinHistoryPoint.fake(timestamp: 1000, price: 100)

        // When
        sut.selectedPoint = point

        // Then
        XCTAssertEqual(sut.selectedPoint?.timestamp, point.timestamp)
        XCTAssertEqual(sut.selectedPoint?.price, point.price)
    }
}
