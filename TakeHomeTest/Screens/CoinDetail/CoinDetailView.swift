//
//  CoinDetailView.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import SwiftUI

struct CoinDetailView: View {
    @ObservedObject private var viewModel: CoinDetailViewModel

    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 20) {
                HeaderView(coin: viewModel.coin, change: viewModel.coinHistory?.change ?? 0.0)

                Picker("Timeframe", selection: $viewModel.selectedTimeframe) {
                    ForEach(viewModel.timeframes, id: \.self) { timeframe in
                        Text(timeframe.title)
                            .tag(timeframe)
                    }
                }
                .pickerStyle(.segmented)

                ChartContainer(viewModel: viewModel)

                StatisticsView(coin: viewModel.coin)
            }
            .listRowSeparator(.hidden)
        }
        .navigationTitle(viewModel.coin.name)
        .listStyle(.plain)
    }

    init(viewModel: CoinDetailViewModel) {
        self.viewModel = viewModel
    }
}
