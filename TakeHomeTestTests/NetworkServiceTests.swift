//
//  NetworkServiceTests.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import XCTest

@testable import TakeHomeTest

class NetworkServiceTests: XCTestCase {
    struct TestRequest: APIRequest {
        typealias Response = Coin
        var endpoint: CoinRankingAPI.Endpoint { .coins(offset: 20, limit: 100) }
        var queryItems: [URLQueryItem] { [] }
    }

    var mockSession: URLSession!
    var networkService: NetworkService!

    override func setUp() {
        super.setUp()

        // Create a mock URLSession with a controlled response
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: config)

        networkService = NetworkService(baseURL: "https://api.test.com", apiKey: "test-api-key", session: mockSession)
    }

    override func tearDown() {
        mockSession = nil
        networkService = nil
        super.tearDown()
    }

    // Test successful response
    func testPerform_SuccessfulResponse() async throws {
        let expectedData = """
            {
                "uuid": "Qwsogvtv82FCd",
                "symbol": "BTC",
                "name": "Bitcoin",
                "color": "#f7931A",
                "iconUrl": "https://cdn.coinranking.com/Sy33Krudb/btc.svg",
                "marketCap": "159393904304",
                "price": "9370.9993109108",
                "listedAt": 1483228800,
                "change": "-0.52",
                "24hVolume": "6818750000",
            }
            """.data(using: .utf8)!

        MockURLProtocol.mockResponse = (
            expectedData,
            HTTPURLResponse(
                url: URL(string: "https://api.test.com")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)!
        )

        let request = TestRequest()
        let result: Coin = try await networkService.perform(request)

        XCTAssertEqual(result.uuid, "Qwsogvtv82FCd")
        XCTAssertEqual(result.name, "Bitcoin")
    }

    // Test unauthorized error (401)
    func testPerform_UnauthorizedError() async {
        MockURLProtocol.mockResponse = (
            Data(),
            HTTPURLResponse(
                url: URL(string: "https://api.test.com")!,
                statusCode: 401,
                httpVersion: nil,
                headerFields: nil)!
        )

        let request = TestRequest()

        do {
            _ = try await networkService.perform(request)
            XCTFail("Expected an error, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error.localizedDescription, NetworkError.unauthorized.localizedDescription)
        } catch {
            XCTFail("Unexpected error type")
        }
    }

    // Test rate limit exceeded (429)
    func testPerform_RateLimitExceeded() async {
        MockURLProtocol.mockResponse = (
            Data(),
            HTTPURLResponse(
                url: URL(string: "https://api.test.com")!,
                statusCode: 429,
                httpVersion: nil,
                headerFields: nil)!
        )

        let request = TestRequest()

        do {
            _ = try await networkService.perform(request)
            XCTFail("Expected an error, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error.localizedDescription, NetworkError.rateLimitExceeded.localizedDescription)
        } catch {
            XCTFail("Unexpected error type")
        }
    }

    // Test server error (500)
    func testPerform_ServerError() async {
        MockURLProtocol.mockResponse = (
            Data(),
            HTTPURLResponse(
                url: URL(string: "https://api.test.com")!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil)!
        )

        let request = TestRequest()

        do {
            _ = try await networkService.perform(request)
            XCTFail("Expected an error, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error.localizedDescription, NetworkError.serverError.localizedDescription)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
}
