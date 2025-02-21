//
//  Coins.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import Foundation

struct Coins {
    let coins: [Coin]

    enum CodingKeys: CodingKey {
        case data
    }

    enum DataCodingKeys: CodingKey {
        case coins
    }
}

extension Coins: Decodable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: DataCodingKeys.self, forKey: .data)
        self.coins = try nestedContainer.decode([Coin].self, forKey: .coins)
    }
}
