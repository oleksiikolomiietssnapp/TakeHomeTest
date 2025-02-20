//
//  APIRequest.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation

// MARK: - Network Layer Protocol
protocol APIRequest {
    associatedtype Response: Decodable

    var endpoint: CoinRankingAPI.Endpoint { get }
    var queryItems: [URLQueryItem] { get }
}
