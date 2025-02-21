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
    private let baseURL: String
    private let apiKey: String
    private let session: URLSession

    init(baseURL: String = "https://api.coinranking.com/v2", apiKey: String, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.session = session
    }

    func perform<T: APIRequest>(_ request: T) async throws -> T.Response {
        let urlRequest = try createURLRequest(for: request)
        return try await executeRequest(urlRequest)
    }

    private func createURLRequest<T: APIRequest>(for request: T) throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + request.endpoint.path) else {
            throw NetworkError.invalidURL
        }

        components.queryItems = request.queryItems

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(apiKey, forHTTPHeaderField: "x-access-token")
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData

        return urlRequest
    }

    private func executeRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)
            try validateResponse(response)
            return try decodeResponse(data)
        } catch let error as NetworkError {
            throw error
        } catch let error as DecodingError {
            throw NetworkError.decodingError(error)
        } catch {
            throw NetworkError.networkError(error)
        }
    }

    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200:
            return
        case 401:
            throw NetworkError.unauthorized
        case 429:
            throw NetworkError.rateLimitExceeded
        case 500...599:
            throw NetworkError.serverError
        default:
            throw NetworkError.invalidResponse
        }
    }

    private func decodeResponse<T: Decodable>(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
