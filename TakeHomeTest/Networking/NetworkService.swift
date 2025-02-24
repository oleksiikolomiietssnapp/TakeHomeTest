//
//  NetworkService.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation

/// Protocol defining the core networking capabilities
protocol NetworkServicing {
    /// Performs a network request and returns the decoded response
    /// - Parameter request: The API request to perform
    /// - Returns: The decoded response matching the request's Response type
    /// - Throws: NetworkError if the request fails
    func perform<T: APIRequest>(_ request: T) async throws -> T.Response
}

/// Main networking service responsible for executing API requests
final class NetworkService: NetworkServicing {
    // MARK: - Properties
    private let configuration: APIConfiguring
    private let session: URLSession

    init(configuration: APIConfiguring, session: URLSession = .shared) {
        self.configuration = configuration
        self.session = session
    }

    // MARK: - Public Methods
    func perform<T: APIRequest>(_ request: T) async throws -> T.Response {
        let urlRequest = try createURLRequest(for: request)
        return try await executeRequest(urlRequest)
    }

    // MARK: - Private Methods
    /// Creates a URLRequest from an APIRequest
    private func createURLRequest<T: APIRequest>(for request: T) throws -> URLRequest {
        var components = URLComponents(string: configuration.baseURL + request.endpoint.path)
        components?.queryItems = request.queryItems

        guard let url = components?.url, url.scheme != nil else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(configuration.apiKey, forHTTPHeaderField: "x-access-token")
        urlRequest.cachePolicy = .returnCacheDataElseLoad

        return urlRequest
    }

    /// Executes a network request and decodes the response
    private func executeRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await performNetworkCall(request)
        try validateResponse(response)
        return try decodeResponse(data)
    }

    /// Performs the actual network call
    private func performNetworkCall(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(for: request)
        } catch {
            throw NetworkError.networkError(error)
        }
    }

    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        let statusCode = httpResponse.statusCode

        switch statusCode {
        case 200: return
        case 401: throw NetworkError.unauthorized
        case 429: throw NetworkError.rateLimitExceeded
        case 500...599: throw NetworkError.serverError
        case 200...299: throw NetworkError.invalidResponse  // Non-200 success status
        case 400...499: throw NetworkError.invalidResponse  // Unhandled client error
        default: throw NetworkError.invalidResponse  // Unknown status code
        }
    }

    /// Decodes the response data into the expected type
    private func decodeResponse<T: Decodable>(_ data: Data) throws -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw NetworkError.decodingError(error)
        } catch {
            throw NetworkError.invalidResponse
        }
    }
}
