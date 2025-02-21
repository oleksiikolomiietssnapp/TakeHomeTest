//
//  FavoritesViewModel.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation
import UIKit

// MARK: - View Model
final class FavoritesViewModel {
    // MARK: - Types
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Coin>

    enum Section {
        case main
    }

    // MARK: - Properties
    private(set) var coins: [Coin] = []
    private let favoriteManager: FavoritesManaging

    init(favoriteManager: FavoritesManaging = FavoritesManager.shared) {
        self.favoriteManager = favoriteManager

        favoriteManager.addObserver { [weak self] coins in
            self?.coins = Array(coins)
        }
    }

    // MARK: - Snapshot Management
    public func snapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(coins, toSection: .main)
        return snapshot
    }

    // MARK: - Methods
    func removeFavorite(_ coin: Coin) {
        favoriteManager.toggleFavorite(coin)
    }
}
