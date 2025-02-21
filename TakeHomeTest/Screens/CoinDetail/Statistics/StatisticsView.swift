//
//  StatisticsView.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import SwiftUI

struct StatisticsView: View {
    private let coin: Coin
    private let columns: [GridItem]

    var body: some View {
        VStack(spacing: 16) {
            Text("Statistics")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)

            LazyVGrid(columns: columns, spacing: 16) {
                StatisticsCard(title: "Market Cap", value: coin.marketCap)
                StatisticsCard(title: "Volume 24h", value: coin.volume24h)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    internal init(coin: Coin) {
        self.coin = coin
        self.columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]
    }
}
