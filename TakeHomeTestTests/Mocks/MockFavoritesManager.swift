//
//  MockFavoritesManager.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import Foundation
@testable import TakeHomeTest

final class MockFavoritesManager: FavoritesManaging {
    private(set) var favorites: [Coin] = []
    private var observers: [([Coin]) -> Void] = []

    var addObserverCalled = false
    var toggleFavoriteCalled = false
    var isFavoriteCalled = false
    var notifyObserversCalled = false
    var lastToggledCoin: Coin?
    var lastAddedObserver: (([Coin]) -> Void)?

    func addObserver(_ observer: @escaping ([Coin]) -> Void) {
        addObserverCalled = true
        lastAddedObserver = observer
        observers.append(observer)
        observer(favorites)
    }

    func toggleFavorite(_ item: Coin) {
        toggleFavoriteCalled = true
        lastToggledCoin = item

        if favorites.contains(item) {
            favorites.removeAll(where: { $0 == item })
        } else {
            favorites.append(item)
        }
        notifyObservers()
    }

    func isFavorite(_ item: Coin) -> Bool {
        isFavoriteCalled = true
        return favorites.contains(item)
    }

    private func notifyObservers() {
        notifyObserversCalled = true
        observers.forEach { $0(favorites) }
    }

    func inject(coins: [Coin]) {
        favorites = coins
        notifyObservers()
    }
}
