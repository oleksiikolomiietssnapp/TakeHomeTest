//
//  LargeNumberFormatter.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import Foundation

// Custom formatter for converting large numbers into readable formats (K, M, B, T)
final class LargeNumberFormatter: Formatter {
    private var numberFormatter: NumberFormatter

    init(numberFormatter: NumberFormatter = .largeStatisticNumberFormatter) {
        self.numberFormatter = numberFormatter
        super.init()
    }

    required init?(coder: NSCoder) {
        self.numberFormatter = .largeStatisticNumberFormatter // Provide a default value
        super.init(coder: coder)
    }

    // Converts a Double into a formatted string representation
    func string(from number: Double) -> String {
        let absNumber = abs(number)  // Get the absolute value
        let sign = number < 0 ? "-" : ""  // Store the negative sign if applicable

        let formatted: String?
        let suffix: String

        switch absNumber {
        case 999_999_999_000...:
            // Trillions (T)
            formatted = numberFormatter.string(from: NSNumber(value: absNumber / 1_000_000_000_000))
            suffix = "T"

        case 999_999_000...:
            // Billions (B)
            formatted = numberFormatter.string(from: NSNumber(value: absNumber / 1_000_000_000))
            suffix = "B"

        case 1_000_000...:
            // Millions (M)
            formatted = numberFormatter.string(from: NSNumber(value: absNumber / 1_000_000))
            suffix = "M"

        default:
            // Format regular numbers with dot separators for readability
            formatted = String(format: "%.0f", absNumber)
                .reversed()
                .enumerated()
                .map { $0.offset > 0 && $0.offset % 3 == 0 ? String($0.element) + "." : String($0.element) }
                .reversed()
                .joined()
            suffix = "" // No suffix for regular numbers
        }

        // If a formatted value is available, return it with the sign and suffix
        if let formatted {
            return sign + formatted + suffix
        }

        return "0.0"  // Default return for invalid input
    }
}
