//
//  StatisticsView.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import SwiftUI

struct StatisticsView: View {
    let coin: Coin

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        VStack(spacing: 16) {
            Text("Statistics")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)

            LazyVGrid(columns: columns, spacing: 16) {
                StatisticsCard(title: "Market Cap", value: formatLargeNumber(coin.marketCap))
                StatisticsCard(title: "Volume 24h", value: formatLargeNumber(coin.volume24h))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private func formatLargeNumber(_ number: Double) -> String {
        let numberFormatter = NumberFormatter.largeNumberFormatter
        switch number {
        case 1_000_000_000_000...:
            return "\(numberFormatter.string(from: NSNumber(value: number / 1_000_000_000_000)) ?? "0")T"
        case 1_000_000_000...:
            return "\(numberFormatter.string(from: NSNumber(value: number / 1_000_000_000)) ?? "0")B"
        case 1_000_000...:
            return "\(numberFormatter.string(from: NSNumber(value: number / 1_000_000)) ?? "0")M"
        default:
            return numberFormatter.string(from: NSNumber(value: number)) ?? "0"
        }
    }
}
