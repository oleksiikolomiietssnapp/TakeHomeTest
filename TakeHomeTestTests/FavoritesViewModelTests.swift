//
//  MockFavoritesManager.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import XCTest
@testable import TakeHomeTest

final class FavoritesViewModelTests: XCTestCase {
    var sut: FavoritesViewModel!
    var mockFavoritesManager: MockFavoritesManager!
    
    override func setUp() {
        super.setUp()
        mockFavoritesManager = MockFavoritesManager()
        sut = FavoritesViewModel(favoriteManager: mockFavoritesManager)
    }
    
    override func tearDown() {
        sut = nil
        mockFavoritesManager = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Then
        XCTAssertEqual(sut.coins.count, 0)
        
        let snapshot = sut.snapshot()
        XCTAssertEqual(snapshot.numberOfItems, 0)
        XCTAssertEqual(snapshot.numberOfSections, 1)
    }
    
    func testSnapshotWithCoins() {
        // Given
        let coin1 = Coin.fake(id: "bitcoin", name: "Bitcoin", symbol: "BTC")
        let coin2 = Coin.fake(id: "ethereum", name: "Ethereum", symbol: "ETH")
        let favorites = [coin1, coin2]
        
        // When
        mockFavoritesManager.inject(coins: favorites)

        // Then
        XCTAssertEqual(sut.coins.count, 2)
        
        let snapshot = sut.snapshot()
        XCTAssertEqual(snapshot.numberOfItems, 2)
        XCTAssertEqual(snapshot.numberOfSections, 1)
        XCTAssertTrue(snapshot.itemIdentifiers.contains(coin1))
        XCTAssertTrue(snapshot.itemIdentifiers.contains(coin2))
    }
    
    func testRemoveFavorite() {
        // Given
        let coin = Coin.fake(id: "bitcoin", name: "Bitcoin", symbol: "BTC")
        mockFavoritesManager.inject(coins: [coin])

        // When
        sut.removeFavorite(coin)
        
        // Then
        XCTAssertTrue(mockFavoritesManager.toggleFavoriteCalled)
        XCTAssertEqual(mockFavoritesManager.lastToggledCoin, coin)
    }
    
    func testObserverUpdatesCoinsArray() {
        // Given
        let coin1 = Coin.fake(id: "bitcoin", name: "Bitcoin", symbol: "BTC")
        let coin2 = Coin.fake(id: "ethereum", name: "Ethereum", symbol: "ETH")
        
        // When
        mockFavoritesManager.inject(coins: [coin1])

        // Then
        XCTAssertEqual(sut.coins.count, 1)
        XCTAssertEqual(sut.coins.first, coin1)
        
        // When adding another coin
        mockFavoritesManager.inject(coins: [coin1, coin2])

        // Then
        XCTAssertEqual(sut.coins.count, 2)
        XCTAssertTrue(sut.coins.contains(coin1))
        XCTAssertTrue(sut.coins.contains(coin2))
    }
}
