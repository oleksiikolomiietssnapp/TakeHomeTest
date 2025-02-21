//
//  CoinsListViewModel.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation
import OSLog
import UIKit

final class CoinsListViewModel: ObservableObject {
    // MARK: - Types
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Coin>

    enum Section {
        case main
    }

    // MARK: - Published Properties
    @Published private(set) var state: CoinsListState = .initial

    // MARK: - Private Properties
    private let favoriteManager: FavoritesManaging
    private let itemsPerPage = 20
    private let maxPages = 5
    private let api: CoinRankingAPIProtocol.Type
    private var isFetching = false

    // MARK: - Initialization
    init(
        initialState: CoinsListState = .initial,
        favoriteManager: FavoritesManaging = FavoritesManager.shared,
        api: CoinRankingAPIProtocol.Type = CoinRankingAPI.self
    ) {
        self.state = initialState
        self.favoriteManager = favoriteManager
        self.api = api
    }

    // MARK: - Public Interface
    public var coins: [Coin] { state.coins }
    public var isLoading: Bool { state.isLoading }
    public var currentPage: Int { state.currentPage }
    public var hasMorePages: Bool { state.hasMorePages }

    // MARK: - Snapshot Management
    public func snapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(state.coins, toSection: .main)
        return snapshot
    }

    // MARK: - Data Loading
    public func loadInitialData() async {
        guard !state.isLoading else { return }

        state.coins = []
        state.currentPage = 0
        state.hasMorePages = true
        await loadNextPage()
    }

    @discardableResult
    public func loadNextPage() async -> Bool {
        guard !state.isLoading && state.hasMorePages && !isFetching else { return false }

        isFetching = true
        state.isLoading = true
        state.error = nil

        do {
            let new = try await api.fetchCoins(
                offset: state.currentPage * itemsPerPage,
                limit: itemsPerPage
            )

            handleNewCoins(new.coins)
        } catch {
            handleError(error)
        }

        state.isLoading = false
        isFetching = false

        return true
    }

    // MARK: - Data Manipulation
    public func sortCoins(by option: SortOption) {
        state.coins.sort(by: option.comparator)
    }

    public func reset() {
        state = .initial
    }

    // MARK: - Search
    public func filterCoins(with searchText: String) async {
        guard !searchText.isEmpty else {
            await loadInitialData()
            return
        }

        let filteredCoins = state.coins.filter { coin in
            coin.name.localizedCaseInsensitiveContains(searchText) ||
            coin.symbol.localizedCaseInsensitiveContains(searchText)
        }

        state.coins = filteredCoins
    }

    // MARK: - Manage favorite
    public func addToFavorite(_ coin: Coin) {
        favoriteManager.toggleFavorite(coin)
    }

    public func removeFromFavorite(_ coin: Coin) {
        favoriteManager.toggleFavorite(coin)
    }

    public func isFavorite(_ coin: Coin) -> Bool {
        favoriteManager.isFavorite(coin)
    }

    // MARK: - Private Helpers
    private func handleNewCoins(_ newCoins: [Coin]) {
        if newCoins.isEmpty || state.currentPage > maxPages {
            state.hasMorePages = false
        } else {
            state.coins.append(contentsOf: newCoins)
            state.currentPage += 1
        }
    }

    private func handleError(_ error: Error) {
        state.error = error
        os_log(.error, "Error loading coins: %@", error.localizedDescription)
    }
}

// MARK: - Error Handling
extension CoinsListViewModel {
    var errorMessage: String? {
        state.error?.localizedDescription
    }

    var hasError: Bool {
        state.error != nil
    }

    func clearError() {
        state.error = nil
    }
}

// MARK: - Testing Helpers
extension CoinsListViewModel {
    #if DEBUG
    func inject(coins: [Coin]) {
        state.coins = coins
    }

    func simulateError(_ error: Error) {
        handleError(error)
    }
    #endif
}
