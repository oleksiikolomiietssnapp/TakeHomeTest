//
//  MockURLProtocol.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation
@testable import TakeHomeTest

class MockURLProtocol: URLProtocol {
    static var mockResponse: (Data, HTTPURLResponse)?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let response = MockURLProtocol.mockResponse {
            self.client?.urlProtocol(self, didReceive: response.1, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: response.0)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
