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

        networkService = NetworkService(
            configuration: ApiConfiguration.testing(),
            session: mockSession
        )
    }

    override func tearDown() {
        mockSession = nil
        networkService = nil
        MockURLProtocol.mockError = nil
        MockURLProtocol.requestHandler = nil
        MockURLProtocol.mockResponse = nil
        super.tearDown()
    }

    // Test successful response
    func testPerformSuccessfulResponse() async throws {
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
    func testPerformUnauthorizedError() async {
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
    func testPerformRateLimitExceeded() async {
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
    func testPerformServerError() async {
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

    func testPerformNetworkError() async {
        let expectedError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)
        MockURLProtocol.mockError = expectedError

        let request = TestRequest()

        do {
            _ = try await networkService.perform(request)
            XCTFail("Expected an error, but got success")
        } catch let error as NetworkError {
            if case .networkError = error {
                XCTAssertEqual(error.localizedDescription, NetworkError.networkError(expectedError).localizedDescription)
            } else {
                XCTFail("Wrong error type received: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type")
        }
    }

    // Test malformed JSON response
    func testPerformMalformedJSONResponse() async {
        let malformedData = """
                {
                    "uuid": "Qwsogvtv82FCd",
                    "symbol": "BTC",
                    MALFORMED_JSON
                }
                """.data(using: .utf8)!
        let context = DecodingError.Context(
            codingPath: [],
            debugDescription: "The data couldn’t be read because it isn’t in the correct format."
        )

        let error = DecodingError.dataCorrupted(context)
        let expectedError = NetworkError.decodingError(error)

        MockURLProtocol.mockResponse = (
            malformedData,
            HTTPURLResponse(
                url: URL(string: "https://api.test.com")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)!
        )
        
        let request = TestRequest()
        
        do {
            _ = try await networkService.perform(request)
            XCTFail("Expected an error, but got success")
        } catch let error as NetworkError {
            if case .decodingError = error {
                XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
            } else {
                XCTFail("Wrong error type received: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type")
        }
    }

    // Test empty response
    func testPerformEmptyResponse() async {
        MockURLProtocol.mockResponse = (
            Data(),
            HTTPURLResponse(
                url: URL(string: "https://api.test.com")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)!
        )

        let request = TestRequest()

        do {
            _ = try await networkService.perform(request)
            XCTFail("Expected an error, but got success")
        } catch let error as NetworkError {
            if case .decodingError = error {
                // Success
            } else {
                XCTFail("Wrong error type received: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    // Test request header validation
    func testPerformRequestHeadersValidation() async {
        var capturedRequest: URLRequest?
        MockURLProtocol.requestHandler = { request in
            capturedRequest = request
            throw NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled)
        }

        let request = TestRequest()

        do {
            _ = try await networkService.perform(request)
        } catch {
            // Verify headers
            XCTAssertEqual(capturedRequest?.value(forHTTPHeaderField: "x-access-token"), "test-api-key")
            XCTAssertEqual(capturedRequest?.cachePolicy, .returnCacheDataElseLoad)
        }
    }
    func testPerformInvalidURL() async {
        let configuration = ApiConfiguration.testing(environment: MockEnvironment(baseURL: " "))
        let networkWithInvalidURL = NetworkService(
            configuration: configuration,
            session: mockSession
        )
        let request = TestRequest()

        do {
            _ = try await networkWithInvalidURL.perform(request)
            XCTFail("Expected an error, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error.localizedDescription, NetworkError.invalidURL.localizedDescription)
        } catch {
            XCTFail("Unexpected error type")
        }
    }

    // Test non-HTTP response
    func testPerformNonHTTPResponse() async {
        MockURLProtocol.mockResponse = (
            Data(),
            URLResponse(
                url: URL(string: "https://api.test.com")!,
                mimeType: nil,
                expectedContentLength: 0,
                textEncodingName: nil)
        )

        let request = TestRequest()

        do {
            _ = try await networkService.perform(request)
            XCTFail("Expected an error, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error.localizedDescription, NetworkError.invalidResponse.localizedDescription)
        } catch {
            XCTFail("Unexpected error type")
        }
    }

    func testPerformUnsupportedError() async {
        MockURLProtocol.mockResponse = (
            Data(),
            HTTPURLResponse(
                url: URL(string: "https://api.test.com")!,
                statusCode: 602,
                httpVersion: nil,
                headerFields: nil)!
        )

        let request = TestRequest()

        do {
            _ = try await networkService.perform(request)
            XCTFail("Expected an error, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error.localizedDescription, NetworkError.invalidResponse.localizedDescription)
        } catch {
            XCTFail("Unexpected error type")
        }
    }

}

struct MockEnvironment: EnvironmentProtocol {
    var baseURL: String
}
