//
//  MockNetworkService.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import Foundation

@testable import TakeHomeTest

enum MockNetworkError: Error {
    case testError
}

final class MockNetworkService: NetworkServicing {
    var performCallCount = 0
    var lastRequest: (any APIRequest)?

    var mockResult: Any?
    var mockError: Error?

    func perform<T: APIRequest>(_ request: T) async throws -> T.Response {
        performCallCount += 1
        lastRequest = request

        if let error = mockError {
            throw error
        }

        if let result = mockResult as? T.Response {
            return result
        }

        throw NSError(domain: "Mock", code: -1, userInfo: [NSLocalizedDescriptionKey: "No mock result set"])
    }
}

struct MockCoin: Decodable {
    let id: String
}
