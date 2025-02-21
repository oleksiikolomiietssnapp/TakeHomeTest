//
//  APIConfiguring.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import Foundation

protocol APIConfiguring {
    var baseURL: String { get }
    var apiKey: String { get }
    var environment: EnvironmentProtocol { get }
}

struct ApiConfiguration: APIConfiguring {
    let baseURL: String
    let apiKey: String
    let environment: EnvironmentProtocol

    init(environment: EnvironmentProtocol = Environment.development, apiKey: String) {
        self.environment = environment
        self.baseURL = environment.baseURL
        self.apiKey = apiKey
    }

    // Helper method to create development configuration
    static func development(apiKey: String) -> ApiConfiguration {
        ApiConfiguration(environment: Environment.development, apiKey: apiKey)
    }

    // Helper method to create production configuration
    static func testing(environment: EnvironmentProtocol = Environment.testing("https://test.com")) -> ApiConfiguration {
        ApiConfiguration(environment: environment, apiKey: "test-api-key")
    }
}
