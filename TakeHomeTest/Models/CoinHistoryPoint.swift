//
//  CoinHistoryPoint.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import Foundation

struct CoinHistoryPoint {
    let id: UUID
    let timestamp: TimeInterval
    let price: Double?

    var date: Date {
        Date(timeIntervalSince1970: timestamp)
    }
}

extension CoinHistoryPoint: Decodable {
    enum CodingKeys: CodingKey {
        case timestamp, price
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.timestamp = try container.decode(Double.self, forKey: .timestamp)
        self.price = container.decodeNumericIfPresent(Double.self, forKey: .price)
    }
}

extension CoinHistoryPoint: Hashable {}
