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
        // Check if the key is present in the container
        guard contains(key) else {
            throw DecodingError.keyNotFound(
                key,
                DecodingError.Context(
                    codingPath: self.codingPath,
                    debugDescription: "Key '\(key.stringValue)' not found")
            )
        }

        // Attempt to decode the value as a numeric type or a string convertible to a numeric type
        if let numeric = decodeNumericIfPresent(type, forKey: key) {
            return numeric
        }

        // If the value is not present or cannot be decoded, throw a corrupted data error
        throw DecodingError.dataCorruptedError(
            forKey: key,
            in: self,
            debugDescription: "Expected \(T.self) or String containing \(T.self)"
        )
    }

    func decodeNumericIfPresent<T: NumericDecodable>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key) -> T? {
        // Try decoding the key as a numeric value
        if let value = try? decode(T.self, forKey: key) {
            return value
        }

        // Try decoding the key as a String and convert it to the numeric type
        if let stringValue = try? decode(String.self, forKey: key),
            let value = T(stringValue)
        {
            return value
        }

        // If neither attempt succeeds, return nil
        return nil
    }
}
