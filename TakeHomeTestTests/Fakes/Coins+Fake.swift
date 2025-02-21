//
//  Coins+Extension.swift
//  TakeHomeTestTests
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import Foundation
@testable import TakeHomeTest

extension Coin {
    static func fake(id: String, name: String, symbol: String = "COIN", price: Double = 1000) -> Coin {
        Coin(uuid: id, name: name, symbol: symbol, iconUrl: "", price: price, change24h: 0, marketCap: 0, volume24h: 0)
    }
}
