//
//  CoinHistoryPoint+Fake.swift
//  TakeHomeTestTests
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import Foundation

@testable import TakeHomeTest

extension CoinHistoryPoint {
    static func fake(timestamp: Double, price: Double) -> CoinHistoryPoint {
        CoinHistoryPoint(id: .init(), timestamp: timestamp, price: price)
    }
}
