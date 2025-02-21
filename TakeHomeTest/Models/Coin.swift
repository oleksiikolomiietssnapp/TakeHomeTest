//
//  Coin.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation


// MARK: - Models
struct Coin {
    let id: UUID
    let uuid: String
    let name: String
    let symbol: String
    let iconUrl: String
    let price: Double
    let change24h: Double
    let marketCap: Double
    let volume24h: Double

    enum CodingKeys: String, CodingKey {
        case uuid
        case name, symbol, iconUrl
        case price = "price"
        case change24h = "change"
        case marketCap
        case volume24h = "24hVolume"
    }

    init(
        id: UUID = UUID(),
        uuid: String,
        name: String,
        symbol: String,
        iconUrl: String,
        price: Double,
        change24h: Double,
        marketCap: Double,
        volume24h: Double
    ) {
        self.id = id
        self.uuid = uuid
        self.name = name
        self.symbol = symbol
        self.iconUrl = iconUrl
        self.price = price
        self.change24h = change24h
        self.marketCap = marketCap
        self.volume24h = volume24h
    }
}

extension Coin: Decodable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = UUID()
        self.uuid = try container.decode(String.self, forKey: .uuid)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.name = try container.decode(String.self, forKey: .name)

        let defaultIconUrl = try container.decode(String.self, forKey: .iconUrl)
        self.iconUrl = defaultIconUrl.replacingOccurrences(of: ".svg", with: ".png")

        self.price = try container.decodeNumeric(Double.self, forKey: .price)
        self.marketCap = try container.decodeNumeric(Double.self, forKey: .marketCap)
        self.volume24h = try container.decodeNumeric(Double.self, forKey: .volume24h)
        self.change24h = try container.decodeNumeric(Double.self, forKey: .change24h)
    }
}

extension Coin: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Coin, rhs: Coin) -> Bool {
        lhs.id == rhs.id
    }
}
