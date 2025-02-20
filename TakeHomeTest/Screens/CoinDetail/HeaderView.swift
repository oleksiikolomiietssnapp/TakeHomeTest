//
//  HeaderView.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import SwiftUI

struct HeaderView: View {
    let coin: Coin
    let change: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                AsyncImage(url: URL(string: coin.iconUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 64, height: 64)

                Text(coin.symbol)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }

            HStack(spacing: 16) {
                Text(coin.price, format: .currency(code: "USD"))
                    .monospacedDigit()
                    .font(.title2)
                    .fontWeight(.semibold)

                PerformanceLabel(change: change)
            }
        }
    }
}
