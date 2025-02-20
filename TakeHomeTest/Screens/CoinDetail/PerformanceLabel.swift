//
//  PerformanceLabel.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import SwiftUI

struct PerformanceLabel: View {
    let change: Double

    var body: some View {
        Text(change/100, format: .percent)
            .monospacedDigit()
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(change >= 0 ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
            .foregroundColor(change >= 0 ? .green : .red)
            .cornerRadius(6)
            .font(.system(.caption, design: .rounded, weight: .medium))
    }
}
