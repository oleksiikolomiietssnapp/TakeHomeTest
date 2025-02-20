//
//  CoinHistoryPoint.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation

extension CoinHistory: Hashable { }
extension CoinHistoryPoint: Hashable { }

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
