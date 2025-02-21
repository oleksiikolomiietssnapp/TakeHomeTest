//
//  MockURLProtocol.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation

@testable import TakeHomeTest

class MockURLProtocol: URLProtocol {
    static var mockResponse: (Data, URLResponse)?
    static var mockError: Error?
    static var requestHandler: ((URLRequest) throws -> Void)?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        defer { self.client?.urlProtocolDidFinishLoading(self) }

        do {
            try MockURLProtocol.requestHandler?(request)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        if let mockError = MockURLProtocol.mockError {
            client?.urlProtocol(self, didFailWithError: mockError)
            return
        }

        if let response = MockURLProtocol.mockResponse {
            self.client?.urlProtocol(self, didReceive: response.1, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: response.0)
        }
    }

    override func stopLoading() {}
}
