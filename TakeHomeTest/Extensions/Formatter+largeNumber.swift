//
//  Formatter+largeNumber.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import Foundation

// Formatter extension to provide a shared instance of LargeNumberFormatter
extension Formatter {
    static let largeNumber: LargeNumberFormatter = LargeNumberFormatter()
}
