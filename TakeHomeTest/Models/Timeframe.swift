//
//  Timeframe.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import Foundation

enum Timeframe: String, CaseIterable {
    case day = "24h"
    case week = "7d"
    case month = "30d"
    case threeMonth = "3m"
    case year = "1y"
    case threeYears = "3y"
    case fiveYears = "5y"

    var title: String {
        rawValue.uppercased()
    }

    func dateString(from date: Date) -> String {
        switch self {
        case .day:
            return DateFormatter.chartDateFormatter.string(from: date)
        case .week, .month:
            return DateFormatter.chartWeekAndMonthFormatter.string(from: date)
        case .threeMonth, .year:
            return DateFormatter.chartMonthFormatter.string(from: date)
        case .threeYears, .fiveYears:
            return DateFormatter.chart5YearsFormatter.string(from: date)
        }
    }
}
