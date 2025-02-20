//
//  CoinDetailViewModel.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation
import Charts
import OSLog

final class CoinDetailViewModel: ObservableObject {
    @Published var coinHistory: CoinHistory? = .init(change: 0.0, points: [])
    @Published var isLoading = false
    @Published var selectedTimeframe: Timeframe = .month {
        didSet {
            Task {
                await fetchChartData()
            }
        }
    }
    @Published var selectedPoint: CoinHistoryPoint?

    public let coin: Coin

    var timeframes: [Timeframe] {
        Timeframe.allCases
    }

    init(coin: Coin) {
        self.coin = coin
        Task {
            await fetchChartData()
        }
    }

    func fetchChartData() async {
        await MainActor.run {
            isLoading = true
        }
        do {
            let coinHistory = try await CoinRankingAPI.fetchCoinHistory(
                id: coin.uuid,
                timePeriod: selectedTimeframe.rawValue
            )

            await MainActor.run {
                self.coinHistory = coinHistory
                self.isLoading = false
            }
        } catch {
            os_log(.error,
                   "Error fetching chart data: %@",
                   error.localizedDescription)
            await MainActor.run {
                self.coinHistory = nil
                isLoading = false
            }
        }
    }

    func updateTimeframe(_ timeframe: Timeframe) {
        selectedTimeframe = timeframe
        Task {
            await fetchChartData()
        }
    }
}
