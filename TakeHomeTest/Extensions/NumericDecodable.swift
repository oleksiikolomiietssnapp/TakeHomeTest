//
//  NumericDecodable.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation

// MARK: - Numeric Decoding Protocol
protocol NumericDecodable: LosslessStringConvertible, Decodable {}

// MARK: - Standard Types Conformance
extension Double: NumericDecodable {}

// MARK: - Keyed Decoding Container Extension
extension KeyedDecodingContainer {
    func decodeNumeric<T: NumericDecodable>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key) throws -> T {
        guard let numeric = decodeNumericIfPresent(type, forKey: key) else {

            throw DecodingError.dataCorruptedError(
                forKey: key,
                in: self,
                debugDescription: "Expected \(T.self) or String containing \(T.self)"
            )
        }

        return numeric
    }

    func decodeNumericIfPresent<T: NumericDecodable>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key) -> T? {
        if let value = try? decode(T.self, forKey: key) {
            return value
        }

        if let stringValue = try? decode(String.self, forKey: key),
           let value = T(stringValue) {
            return value
        }

        return nil
    }
}
