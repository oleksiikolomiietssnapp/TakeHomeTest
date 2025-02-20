//
//  SortOption.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation

// MARK: - Sort Options
enum SortOption {
    case price
    case performance24h

    var comparator: (Coin, Coin) -> Bool {
        switch self {
        case .price:
            return { $0.price > $1.price }
        case .performance24h:
            return { $0.change24h > $1.change24h }
        }
    }
}
