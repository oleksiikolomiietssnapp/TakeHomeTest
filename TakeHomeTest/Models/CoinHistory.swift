//
//  CoinHistoryPoint.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation

struct CoinHistory {
    let change: Double
    let points: [CoinHistoryPoint]

    enum CoinHistoryCodingKeys: CodingKey {
        case change
        case history
    }

    enum CodingKeys: CodingKey {
        case data
    }
}

extension CoinHistory: Decodable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: CoinHistoryCodingKeys.self, forKey: .data)
        self.change = try nestedContainer.decodeNumeric(Double.self, forKey: .change)
        self.points = try nestedContainer.decode([CoinHistoryPoint].self, forKey: .history)
    }
}

extension CoinHistory: Hashable {}
