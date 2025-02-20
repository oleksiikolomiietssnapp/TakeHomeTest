//
//  FavoritesManager.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation

final class FavoritesManager {
    static let shared = FavoritesManager()

    private init() {}

    private(set) var favorites: [Coin] = []
    private var observers: [([Coin]) -> Void] = []

    func addObserver(_ observer: @escaping ([Coin]) -> Void) {
        observers.append(observer)
        observer(favorites)
    }

    func toggleFavorite(_ item: Coin) {
        if favorites.contains(item) {
            favorites.removeAll(where: { $0 == item})
        } else {
            favorites.append(item)
        }
        notifyObservers()
    }

    func isFavorite(_ item: Coin) -> Bool {
        favorites.contains(item)
    }

    private func notifyObservers() {
        observers.forEach { $0(favorites) }
    }
}
