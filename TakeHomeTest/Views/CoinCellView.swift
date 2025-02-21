//
//  CoinCellView.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import SwiftUI

struct CoinCellView: View {
    let coin: Coin

    var body: some View {
        HStack(spacing: 12) {
            // Coin Icon
            AsyncImage(url: URL(string: coin.iconUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.large)
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())

            // Coin Info
            VStack(alignment: .leading, spacing: 4) {
                Text(coin.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(coin.symbol)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }

            // Price and Change
            VStack(alignment: .trailing, spacing: 4) {
                Text(coin.price, format: .currency(code: "USD"))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)

                Text(coin.change24h/100, format: .percent)
                    .font(.system(size: 14))
                    .foregroundColor(coin.change24h >= 0 ? .green : .red)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}

#if DEBUG
struct CoinCellView_Previews: PreviewProvider {
    static var previews: some View {
        CoinCellView(coin: Coin(
            uuid: "1",
            name: "Bitcoin",
            symbol: "BTC",
            iconUrl: "https://cryptologos.cc/logos/bitcoin-btc-logo.png?v=040",
            price: 45000.00,
            change24h: 2.5,
            marketCap: 800000000000,
            volume24h: 28000000000
        ))
        .previewLayout(.sizeThatFits)
    }
}
#endif
