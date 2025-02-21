//
//  Environment.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import Foundation

protocol EnvironmentProtocol {
    var baseURL: String { get }
}

enum Environment: EnvironmentProtocol {
    case development
    case testing(String)

    var baseURL: String {
        switch self {
        case .development:
            return "https://api.coinranking.com/v2"
        case .testing(let path):
            return path
        }
    }
}
