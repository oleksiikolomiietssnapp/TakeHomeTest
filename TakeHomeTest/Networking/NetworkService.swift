//
//  NetworkService.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation

protocol NetworkServicing {
    func perform<T: APIRequest>(_ request: T) async throws -> T.Response
}

// MARK: - Network Service
final class NetworkService: NetworkServicing {
    private let configuration: APIConfiguring
    private let session: URLSession

    init(configuration: APIConfiguring, session: URLSession = .shared) {
        self.configuration = configuration
        self.session = session
    }

    func perform<T: APIRequest>(_ request: T) async throws -> T.Response {
        let urlRequest = try createURLRequest(for: request)
        return try await executeRequest(urlRequest)
    }

    private func createURLRequest<T: APIRequest>(for request: T) throws -> URLRequest {
        var components = URLComponents(string: configuration.baseURL + request.endpoint.path)
        components?.queryItems = request.queryItems

        guard let url = components?.url, url.scheme != nil else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(configuration.apiKey, forHTTPHeaderField: "x-access-token")
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData

        return urlRequest
    }

    private func executeRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await performNetworkCall(request)
        try validateResponse(response)
        return try decodeResponse(data)
    }

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
