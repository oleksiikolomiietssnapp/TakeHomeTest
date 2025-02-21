//
//  CoinsListViewModelTests.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import XCTest

@testable import TakeHomeTest

final class CoinsListViewModelTests: XCTestCase {
    // MARK: - Properties
    private var sut: CoinsListViewModel!
    private var mockFavoritesManager: MockFavoritesManager!

    // MARK: - Test Lifecycle
    override func setUp() {
        super.setUp()
        mockFavoritesManager = MockFavoritesManager()
        MockCoinRankingAPI.mockCoins = .init(coins: [])
        MockCoinRankingAPI.shouldThrowError = false
        sut = CoinsListViewModel(
            favoriteManager: mockFavoritesManager,
            api: MockCoinRankingAPI.self
        )
    }

    override func tearDown() {
        sut = nil
        mockFavoritesManager = nil
        MockCoinRankingAPI.mockCoins = .init(coins: [])
        MockCoinRankingAPI.shouldThrowError = false
        super.tearDown()
    }

    // MARK: - Initial State Tests
    func testInitialState() {
        XCTAssertTrue(sut.coins.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.currentPage, 0)
        XCTAssertTrue(sut.hasMorePages)
        XCTAssertFalse(sut.hasError)
        XCTAssertNil(sut.errorMessage)
    }

    // MARK: - Data Loading Tests
    func testLoadInitialData_ResetsStateBeforeLoading() async {
        // Given
        let mockCoins = createMockCoins(count: 3)
        sut.inject(coins: mockCoins)
        XCTAssertEqual(sut.coins.count, 3)

        // When
        MockCoinRankingAPI.mockCoins = .init(coins: [])
        sut.reset()

        // Then
        XCTAssertTrue(sut.coins.isEmpty)
        XCTAssertEqual(sut.currentPage, 0)
        XCTAssertTrue(sut.hasMorePages)
    }

    func testLoadInitialData_LoadsFirstPage() async {
        // Given
        let mockCoins = createMockCoins(count: 3)
        MockCoinRankingAPI.mockCoins = .init(coins: mockCoins)

        // When
        await sut.loadInitialData()

        // Then
        XCTAssertEqual(sut.coins.count, 3)
        XCTAssertEqual(sut.currentPage, 1)
        XCTAssertTrue(sut.hasMorePages)
    }

    func testLoadNextPage_WhenHasMorePages_LoadsNewPage() async {
        // Given
        let newCoins = createMockCoins(count: 20)
        MockCoinRankingAPI.mockCoins = .init(coins: newCoins)

        // When
        let result = await sut.loadNextPage()

        // Then
        XCTAssertTrue(result)
        XCTAssertEqual(sut.currentPage, 1)
        XCTAssertEqual(sut.coins.count, 20)
    }

    func testLoadNextPage_WhenReachesMaxPages_StopsLoading() async {
        // Given
        sut.inject(coins: createMockCoins(count: 100))

        // When
        for _ in 0...5 {
            _ = await sut.loadNextPage()
        }

        // Then
        XCTAssertFalse(sut.hasMorePages)
    }

    func testLoadNextPage_WhenGetApiError() async {
        // Given
        sut.inject(coins: createMockCoins(count: 100))
        MockCoinRankingAPI.shouldThrowError = true

        // When
        for _ in 0...5 {
            _ = await sut.loadNextPage()
        }

        // Then
        XCTAssertNotNil(sut.state.error)
    }

    // MARK: - Sorting Tests
    func testSortCoins_BySortOption_SortsCorrectly() {
        // Given
        let coin1 = Coin.fake(id: "1", name: "Bitcoin", price: 50000)
        let coin2 = Coin.fake(id: "2", name: "Ethereum", price: 3000)
        let coin3 = Coin.fake(id: "3", name: "AltCoin", price: 1000)
        sut.inject(coins: [coin1, coin2, coin3])

        // When sorting by price
        sut.sortCoins(by: .price)

        // Then
        XCTAssertEqual(sut.coins[0].price, 50000)
        XCTAssertEqual(sut.coins[1].price, 3000)
        XCTAssertEqual(sut.coins[2].price, 1000)
    }

    // MARK: - Search Tests
    func testFilterCoins_WithEmptySearchText_LoadsAllCoins() async {
        // Given
        let mockCoins = createMockCoins(count: 3)
        sut.inject(coins: mockCoins)
        MockCoinRankingAPI.mockCoins = .init(coins: mockCoins)

        // When
        await sut.filterCoins(with: "")

        // Then
        XCTAssertEqual(sut.coins.count, 3)
    }

    func testFilterCoins_WithSearchText_FiltersCorrectly() async {
        // Given
        let coin1 = Coin.fake(id: "1", name: "Bitcoin", symbol: "BTC")
        let coin2 = Coin.fake(id: "2", name: "Ethereum", symbol: "ETH")
        sut.inject(coins: [coin1, coin2])

        // When
        await sut.filterCoins(with: "bit")

        // Then
        XCTAssertEqual(sut.coins.count, 1)
        XCTAssertEqual(sut.coins.first?.name, "Bitcoin")
    }

    // MARK: - Favorites Tests
    func testAddToFavorite_CallsFavoriteManager() {
        // Given
        let coin = Coin.fake(id: "1", name: "Bitcoin")

        // When
        sut.addToFavorite(coin)

        // Then
        XCTAssertTrue(mockFavoritesManager.toggleFavoriteCalled)
        XCTAssertEqual(mockFavoritesManager.lastToggledCoin?.id, coin.id)
    }

    func testAddAndRemoveFromFavorite_CallsFavoriteManager() {
        // Given
        let coin = Coin.fake(id: "1", name: "Bitcoin")

        // When
        sut.addToFavorite(coin)

        // Then
        XCTAssertTrue(mockFavoritesManager.toggleFavoriteCalled)
        XCTAssertEqual(mockFavoritesManager.lastToggledCoin?.id, coin.id)

        // When
        sut.removeFromFavorite(coin)

        // Then
        XCTAssertFalse(mockFavoritesManager.favorites.contains(coin))
    }


    func testIsFavorite_ReturnsFavoriteManagerResult() {
        // Given
        let coin = Coin.fake(id: "1", name: "Bitcoin")
        mockFavoritesManager.toggleFavorite(coin)

        // When
        let result = sut.isFavorite(coin)

        // Then
        XCTAssertTrue(result)
        XCTAssertTrue(mockFavoritesManager.isFavoriteCalled)

        // Additional verification
        mockFavoritesManager.toggleFavorite(coin)
        let updatedResult = sut.isFavorite(coin)
        XCTAssertFalse(updatedResult)
    }

    // MARK: - Error Handling Tests
    func testHandleError_SetsErrorState() {
        // Given
        let error = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])

        // When
        sut.simulateError(error)

        // Then
        XCTAssertTrue(sut.hasError)
        XCTAssertEqual(sut.errorMessage, "Test error")
    }

    func testClearError_ResetsErrorState() {
        // Given
        sut.simulateError(NSError(domain: "test", code: 1))

        // When
        sut.clearError()

        // Then
        XCTAssertFalse(sut.hasError)
        XCTAssertNil(sut.errorMessage)
    }

    // MARK: - Observer Tests
    func testAddObserver_CallsObserverImmediately() {
        // Given
        var receivedCoins: [Coin]?

        // When
        mockFavoritesManager.addObserver { coins in
            receivedCoins = coins
        }

        // Then
        XCTAssertTrue(mockFavoritesManager.addObserverCalled)
        XCTAssertNotNil(mockFavoritesManager.lastAddedObserver)
        XCTAssertNotNil(receivedCoins)
        XCTAssertTrue(receivedCoins?.isEmpty ?? false)
    }

    func testToggleFavorite_NotifiesObservers() {
        // Given
        var observerCallCount = 0
        mockFavoritesManager.addObserver { _ in
            observerCallCount += 1
        }
        let coin = Coin.fake(id: "1", name: "Bitcoin")
        observerCallCount = 0

        // When
        mockFavoritesManager.toggleFavorite(coin)

        // Then
        XCTAssertTrue(mockFavoritesManager.notifyObserversCalled)
        XCTAssertEqual(observerCallCount, 1)
        XCTAssertTrue(mockFavoritesManager.favorites.contains(coin))

        // When toggling again (removal)
        mockFavoritesManager.toggleFavorite(coin)

        // Then
        XCTAssertEqual(observerCallCount, 2)
        XCTAssertFalse(mockFavoritesManager.favorites.contains(coin))
    }

    // MARK: - Helper Methods
    private func createMockCoins(count: Int) -> [Coin] {
        (0..<count).map { index in
            Coin.fake(id: "\(index)", name: "Coin \(index)", price: 1000)
        }
    }
}
