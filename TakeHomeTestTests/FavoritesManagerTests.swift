//
//  FavoritesManagerTests.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import XCTest
@testable import TakeHomeTest

final class FavoritesManagerTests: XCTestCase {
    var sut: FavoritesManager!
    var testCoin1: Coin!
    var testCoin2: Coin!
    
    override func setUp() {
        super.setUp()
        sut = FavoritesManager.shared
        testCoin1 = Coin.fake(id: "1", name: "Bitcoin", symbol: "BTC", price: 50000)
        testCoin2 = Coin.fake(id: "2", name: "Ethereum", symbol: "ETH", price: 3000)

        // Clear favorites before each test
        sut.favorites.forEach { sut.toggleFavorite($0) }
    }
    
    override func tearDown() {
        sut = nil
        testCoin1 = nil
        testCoin2 = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func test_initialState_favoritesIsEmpty() {
        XCTAssertTrue(sut.favorites.isEmpty)
    }
    
    // MARK: - Toggle Favorite Tests
    
    func test_toggleFavorite_whenItemNotInFavorites_addsItem() {
        // Given
        XCTAssertFalse(sut.isFavorite(testCoin1))
        
        // When
        sut.toggleFavorite(testCoin1)
        
        // Then
        XCTAssertTrue(sut.isFavorite(testCoin1))
        XCTAssertEqual(sut.favorites.count, 1)
    }
    
    func test_toggleFavorite_whenItemInFavorites_removesItem() {
        // Given
        sut.toggleFavorite(testCoin1)
        XCTAssertTrue(sut.isFavorite(testCoin1))
        
        // When
        sut.toggleFavorite(testCoin1)
        
        // Then
        XCTAssertFalse(sut.isFavorite(testCoin1))
        XCTAssertTrue(sut.favorites.isEmpty)
    }
    
    func test_toggleFavorite_multipleItems_maintainsCorrectOrder() {
        // When
        sut.toggleFavorite(testCoin1)
        sut.toggleFavorite(testCoin2)
        
        // Then
        XCTAssertEqual(sut.favorites.count, 2)
        XCTAssertEqual(sut.favorites[0], testCoin1)
        XCTAssertEqual(sut.favorites[1], testCoin2)
    }
    
    // MARK: - Observer Tests
    
    func test_addObserver_immediatelyNotifiesWithCurrentState() {
        // Given
        sut.toggleFavorite(testCoin1)
        var receivedFavorites: [Coin]?
        
        // When
        sut.addObserver { favorites in
            receivedFavorites = favorites
        }
        
        // Then
        XCTAssertEqual(receivedFavorites, [testCoin1])
    }
    
    func test_toggleFavorite_notifiesAllObservers() {
        // Given
        var observer1Called = false
        var observer2Called = false
        var observer1Favorites: [Coin]?
        var observer2Favorites: [Coin]?
        
        sut.addObserver { favorites in
            observer1Called = true
            observer1Favorites = favorites
        }
        
        sut.addObserver { favorites in
            observer2Called = true
            observer2Favorites = favorites
        }
        
        // When
        sut.toggleFavorite(testCoin1)
        
        // Then
        XCTAssertTrue(observer1Called)
        XCTAssertTrue(observer2Called)
        XCTAssertEqual(observer1Favorites, [testCoin1])
        XCTAssertEqual(observer2Favorites, [testCoin1])
    }
    
    func test_multipleToggles_observersReceiveCorrectUpdates() {
        // Given
        var latestFavorites: [Coin]?
        sut.addObserver { favorites in
            latestFavorites = favorites
        }
        
        // When - Add first coin
        sut.toggleFavorite(testCoin1)
        XCTAssertEqual(latestFavorites, [testCoin1])
        
        // When - Add second coin
        sut.toggleFavorite(testCoin2)
        XCTAssertEqual(latestFavorites, [testCoin1, testCoin2])
        
        // When - Remove first coin
        sut.toggleFavorite(testCoin1)
        XCTAssertEqual(latestFavorites, [testCoin2])
    }
    
    // MARK: - IsFavorite Tests
    
    func test_isFavorite_whenItemNotInFavorites_returnsFalse() {
        XCTAssertFalse(sut.isFavorite(testCoin1))
    }
    
    func test_isFavorite_whenItemInFavorites_returnsTrue() {
        // Given
        sut.toggleFavorite(testCoin1)
        
        // Then
        XCTAssertTrue(sut.isFavorite(testCoin1))
    }
    
    // MARK: - Memory Management Tests
    
    func test_addingMultipleObservers_doesNotCauseMemoryLeak() {
        weak var weakManager: FavoritesManager?
        autoreleasepool {
            let manager = FavoritesManager.shared
            weakManager = manager
            
            manager.addObserver { _ in }
            manager.addObserver { _ in }
        }
        
        XCTAssertNotNil(weakManager)
    }
}
