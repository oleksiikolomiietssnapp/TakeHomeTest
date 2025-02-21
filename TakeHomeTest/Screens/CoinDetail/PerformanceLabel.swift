//
//  PerformanceLabel.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import SwiftUI

struct PerformanceLabel: View {
    let change: Double

    private var formattedChange: String {
        (change / 100).formatted(.percent)
    }

    private var backgroundColor: Color {
        change >= 0 ? Color.green.opacity(0.2) : Color.red.opacity(0.2)
    }

    private var textColor: Color {
        change >= 0 ? .green : .red
    }

    var body: some View {
        Text(formattedChange)
            .monospacedDigit()
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(6)
            .font(.system(.caption, design: .rounded, weight: .medium))
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 12) {
        PerformanceLabel(change: 5.4)
        PerformanceLabel(change: -2.3)
        PerformanceLabel(change: 0.0)
    }
    .padding()
}
#endif
