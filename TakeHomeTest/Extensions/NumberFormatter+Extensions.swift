//
//  NumberFormatter.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation

extension NumberFormatter {
    static let chartPriceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 3
        formatter.usesGroupingSeparator = true
        formatter.locale = Locale(identifier: "en_US")  // Ensures proper formatting
        return formatter
    }()

    static let largeStatisticNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = "."
        return formatter
    }()
}
