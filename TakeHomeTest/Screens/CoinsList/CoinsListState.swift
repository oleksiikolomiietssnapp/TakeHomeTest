//
//  CoinsListState.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation

// MARK: - View Model State
struct CoinsListState {
    var coins: [Coin]
    var isLoading: Bool
    var error: Error?
    var currentPage: Int
    var hasMorePages: Bool

    static let initial = CoinsListState(
        coins: [],
        isLoading: false,
        error: nil,
        currentPage: 0,
        hasMorePages: true
    )
}
