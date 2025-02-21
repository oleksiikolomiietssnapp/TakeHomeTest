//
//  StatisticsView.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import SwiftUI

struct StatisticsView: View {
    let coin: Coin

    var body: some View {
        VStack(spacing: 16) {
            Text("Statistics")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                ], spacing: 16
            ) {
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
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2

        if number >= 1_000_000_000_000 {
            return "\(formatter.string(from: NSNumber(value: number / 1_000_000_000_000)) ?? "0")T"
        } else if number >= 1_000_000_000 {
            return "\(formatter.string(from: NSNumber(value: number / 1_000_000_000)) ?? "0")B"
        } else if number >= 1_000_000 {
            return "\(formatter.string(from: NSNumber(value: number / 1_000_000)) ?? "0")M"
        }
        return formatter.string(from: NSNumber(value: number)) ?? "0"
    }
}
